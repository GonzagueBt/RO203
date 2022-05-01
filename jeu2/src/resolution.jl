# This file contains methods to solve an instance (heuristically or with CPLEX)
using CPLEX

include("generation.jl")
include("heuristic.jl")

TOL = 0.00001

"""
Solve an instance with CPLEX
"""
function cplexSolve(sizeR::Int64, t::Array{})

    # Create the model
    m = Model(CPLEX.Optimizer)

    ########### Variables ########### 
    n = size(t,1)
    p = size(t,2)
    nbR = round(Int64,n*p/sizeR)
    # x[i,j,k] = 1 if case i,j is in region k
    @variable(m, x[1:n, 1:p, 1:nbR], Bin)
    # y[i,j] = 1 if there exist an arc between case i and j
    @variable(m, y[1:n*p,1:n*p], Bin)

    ########## constraints ##########

    # 1 - each region containte sizeR case
    @constraint(m, [k in 1:nbR], sum(x[i,j,k] for i in 1:n for j in 1:p)==sizeR)

    # 2 - each case belong to only one region
    @constraint(m, [i in 1:n, j in 1:p], sum(x[i,j,k] for k in 1:nbR)==1)

    # 3 the number of palisade of a case is equal to the indicated value
    @constraint(m, [i in 2:n-1, j in 2:p-1; t[i,j]!=0], y[(i-1)*(p)+j,(i-1)*(p)+j+1] + y[(i-1)*(p)+j+1,(i-1)*(p)+j] + y[(i-1)*(p)+j,(i-1)*(p)+j-1] + y[(i-1)*(p)+j-1,(i-1)*(p)+j] + y[(i-1)*(p)+j,(i-2)*p+j] + y[(i-2)*p+j,(i-1)*(p)+j] + y[(i-1)*(p)+j,i*(p)+j] + y[i*(p)+j,(i-1)*(p)+j] == t[i,j])   
        #each side
    @constraint(m, [j in 2:p-1; t[1,j]!=0], y[j,j+1] + y[j+1,j] + y[j,j-1] + y[j-1,j] + y[j,p+j] + y[j+p,j] + 1 == t[1,j])
    @constraint(m, [j in 2:p-1; t[n,j]!=0], y[(n-1)*(p)+j,(n-1)*(p)+j+1] + y[(n-1)*(p)+j+1,(n-1)*(p)+j] + y[(n-1)*(p)+j,(n-1)*(p)+j-1] + y[(n-1)*(p)+j-1,(n-1)*(p)+j] + y[(n-1)*(p)+j,(n-2)*(p)+j] + y[(n-2)*(p)+j,(n-1)*(p)+j] + 1 == t[n,j])

    @constraint(m, [i in 2:n-1; t[i,1]!=0], y[(i-1)*(p)+1,(i-1)*(p)+2] + y[(i-1)*(p)+2,(i-1)*(p)+1] + y[(i-1)*(p)+1,(i-2)*p+1] + y[(i-2)*p+1,(i-1)*(p)+1] + y[(i-1)*p+1,(i)*p+1] + y[(i)*p+1,(i-1)*p+1] + 1 == t[i,1])
    @constraint(m, [i in 2:n-1; t[i,p]!=0], y[(i-1)*(p)+p,(i-1)*p+p-1] + y[(i-1)*p+p-1,(i-1)*(p)+p] + y[(i-1)*p+p,(i-1)*p] + y[(i-1)*p, (i-1)*p+p] + y[(i-1)*(p)+p,(i)*p+p] + y[(i)*p+p,(i-1)*(p)+p] + 1 == t[i,p])
        #each angles
    if t[1,1]!=0
        @constraint(m, y[1,2] + y[2,1] + y[1,p+1] + y[p+1,1] + 2 == t[1,1])
    end
    if t[n,p]!=0
        @constraint(m, y[n*p,n*(p-1)] + y[n*(p-1),n*(p)] + y[n*p,n*p-1] + y[n*p-1,n*p] + 2 == t[n,p])
    end
    if t[1,p]!=0
        @constraint(m, y[p,p-1] + y[p-1,p] + y[p,2*p] + y[2*p,p] + 2 == t[1,p])
    end
    if t[n,1]!=0
        @constraint(m, y[n*(p-1)+1,n*(p-1)+2] + y[n*(p-1)+2,n*(p-1)+1] + y[n*(p-1)+1,n*(p-2)+1] + y[n*(p-2)+1,n*(p-1)+1] + 2 == t[n,1])
    end

    
    # 4 - a case of a region always has at least one neighboord which belong to the same region
    @constraint(m, [i in 2:n-1, j in 2:p-1, k in 1:nbR; sizeR>1],  x[i,j+1,k] + x[i,j-1,k] + x[i+1,j,k] + x[i-1,j,k] >= x[i,j,k])
        #each side 
    @constraint(m, [j in 2:p-1, k in 1:nbR; sizeR>3],  x[1,j+1,k] + x[1,j-1,k] + x[2,j,k] >= x[1,j,k])
    @constraint(m, [j in 2:p-1, k in 1:nbR; sizeR>3],  x[n,j+1,k] + x[n,j-1,k] + x[n-1,j,k] >= x[n,j,k])
    @constraint(m, [i in 2:n-1, k in 1:nbR; sizeR>3],  x[i+1,1,k] + x[i-1,1,k] + x[i,2,k] >= x[i,1,k])
    @constraint(m, [i in 2:n-1, k in 1:nbR; sizeR>3],  x[i+1,p,k] + x[i-1,p,k] + x[i,p-1,k] >= x[i,p,k])
        #each angle
    @constraint(m,[k in 1:nbR; sizeR>1], x[1,2,k] + x[2,1,k] >= x[1,1,k])
    @constraint(m,[k in 1:nbR; sizeR>1], x[n,p-1,k] + x[n-1,p,k] >= x[n,p,k])
    @constraint(m,[k in 1:nbR; sizeR>1], x[n,2,k] + x[n-1,1,k] >= x[n,1,k])
    @constraint(m,[k in 1:nbR; sizeR>1], x[1,p-1,k] + x[2,p,k] >= x[1,p,k])

    # 5 - there exist a palisade between case i and j if there are not in the same region
    @constraint(m, [i in 1:n, j in 1:p-1], y[(i-1)*p+j,(i-1)*p+j+1] + y[(i-1)*p+j+1,(i-1)*p+j]  + sum(x[i,j,k]*x[i,j+1,k] for k in 1:nbR) == 1)
    @constraint(m, [i in 1:n-1, j in 1:p], y[(i-1)*p+j,(i)*p+j] + y[(i)*p+j,(i-1)*p+j]  + sum(x[i,j,k]*x[i+1,j,k] for k in 1:nbR) == 1)
     
    for i in 1:n
        for j in 1:p
            # 6 - the distance between 2 cases of a same region is lower than sizeR-1
            @constraint(m, [a in 1:n, b in 1:p, k in 1:nbR; a!=i && b!=j], x[i,j,k]*x[a,b,k]*(abs(i-a)+abs(j-b))<= sizeR-1 )
            # 7 - the sum of distance betwean a case of a region with all other cases from the same region is lower or equal to the sum of k in 1:sizeR-1
            @constraint(m, [k in 1:nbR], sum( x[i,j,k]*x[a,b,k]*(abs(i-a)+abs(j-b)) for a in 1:n, b in 1:p) <= sum(l for l in 1:sizeR-1))
        end
    end


    # Start a chronometer
    start = time()

    # Solve the model
    optimize!(m)

    execTime = time() - start

    xbis = Array{Int64}(zeros(n,p))
    for i in 1:n
        for j in 1:p
            for k in 1:nbR
                if JuMP.value(x[i,j,k])==1
                    xbis[i,j]=k
                end
            end
        end
    end
    # Return:
    # 1 - true if an optimum is found
    # 2 - the resolution time
    return JuMP.primal_status(m) == JuMP.MathOptInterface.FEASIBLE_POINT, execTime, xbis
end

"""
Heuristically solve an instance
"""
function heuristicSolve(sizeR::Int64, t::Array{})
    n = size(t,1)
    m = size(t,2)
    res = Array{Int64}(zeros(n,m))
    rsize = Array{Int64}(zeros(round(Int64,(n*m)/sizeR)))
    palisade = initPalisade(t)
    cpt=0
    while cpt<10
        memory = copy(res)
        res, rsize = firstFilling(rsize, palisade, res, sizeR)
        res, rsize = secondFilling(rsize, palisade, res, sizeR)
        res, rsize = notEnoughPalisade(res, palisade, rsize, sizeR)
        res, rsize = oneMoreCase(t,res, palisade, rsize, sizeR)
        res, rsize = isFreeSpace(res, rsize, sizeR)
        res, rsize = only1notEmpty(res, rsize, sizeR)
        palisade = updatePalisade(rsize, palisade, res, memory, sizeR)
        cpt+=1
    end
    return res
end 

"""
Solve all the instances contained in "../data" through CPLEX and heuristics

The results are written in "../res/cplex" and "../res/heuristic"

Remark: If an instance has previously been solved (either by cplex or the heuristic) it will not be solved again
"""
function solveDataSet()

    dataFolder = "../data/"
    resFolder = "../res/"

    # Array which contains the name of the resolution methods
    resolutionMethod = ["cplex", "heuristic"]
    #resolutionMethod = ["cplex", "heuristique"]

    # Array which contains the result folder of each resolution method
    resolutionFolder = resFolder .* resolutionMethod

    # Create each result folder if it does not exist
    for folder in resolutionFolder
        if !isdir(folder)
            mkdir(folder)
        end
    end
            
    global isOptimal = false
    global solveTime = -1

    # For each instance
    # (for each file in folder dataFolder which ends by ".txt")
    for file in filter(x->occursin(".txt", x), readdir(dataFolder))  
        
        println("-- Resolution of ", file)
        sizeR, t = readInputFile(dataFolder * file)
        
        # For each resolution method
        for methodId in 1:size(resolutionMethod, 1)
            
            outputFile = resolutionFolder[methodId] * "/" * file

            # If the instance has not already been solved by this method
            if !isfile(outputFile)
                
                fout = open(outputFile, "w")  

                resolutionTime = -1
                isOptimal = false
                
                # If the method is cplex
                if resolutionMethod[methodId] == "cplex"
                                        
                    # Solve it and get the results
                    isOptimal, resolutionTime, x = cplexSolve(sizeR, t)
                    
                    # If a solution is found, write it
                    if isOptimal
                        writeSolution(fout,t,x)
                    end

                # If the method is one of the heuristics
                else
                    
                    isSolved = false

                    # Start a chronometer 
                    startingTime = time()
                    
                    # While the grid is not solved and less than 100 seconds are elapsed
                    while !isOptimal && resolutionTime < 100
                        
                        
                        # Solve it and get the results
                        x = heuristicSolve(sizeR, t)
                        isOptimal=false
                        # Stop the chronometer
                        resolutionTime = time() - startingTime
                        
                    end

                    # Write the solution (if any)
                    if isOptimal
                        writeSolution(fout,t,x)
                    end 
                end
                println(fout)
                println(fout, "solveTime = ", resolutionTime) 
                println(fout, "isOptimal = ", isOptimal)
                
                close(fout)
            end


            # Display the results obtained with the method on the current instance
            #include(outputFile)
            println(resolutionMethod[methodId], " optimal: ", isOptimal)
            println(resolutionMethod[methodId], " time: " * string(round(solveTime, sigdigits=2)) * "s\n")
        end         
    end 
end


"""
Write a solution in an output stream

Arguments
- fout: the output stream (usually an output file)
- t: 2-dimensional array of size n*n
"""
function writeSolution(fout::IOStream,t::Array{},x::Array{})
    n = size(t,1)
    m = size(t,2)
    println(fout,"t=[")
    for i in 1:n-1
        print(fout,"[")
        for j in 1:m
            print(fout,x[i,j], " ")
        end
        println(fout,"];")
    end
    print(fout,"[")
    for j in 1:m
        print(fout,x[n,j], " ")
    end
    println(fout,"]")
    println(fout,"]")
end