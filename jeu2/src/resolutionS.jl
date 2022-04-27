# This file contains methods to solve an instance (heuristically or with CPLEX)
using CPLEX

include("generation.jl")

TOL = 0.00001

"""
Solve an instance with CPLEX
"""
function cplexSolve2(sizeR::Int64, t::Array{})

    # Create the model
    m = Model(CPLEX.Optimizer)

    ########### Variables ########### 
    n = size(t,1)
    p = size(t,2)
    nbR = round(Int64,n*p/sizeR)
    # x[i,j,k] = 1 if case i,j is in region k
    @variable(m, x[1:n, 1:p, 1:nbR], Bin)
    # y[i,j,k] = 0 if case i and j are both in the region k (which mean no palisade)
    @variable(m, y[1:n*p,1:n*p, 1:nbR], Bin)

    ########## constraints ##########

    # 1 - each region containte sizeR case
    @constraint(m, [k in 1:nbR], sum(x[i,j,k] for i in 1:n for j in 1:p)==sizeR)

    # 2 - each case belong to only one region
    @constraint(m, [i in 1:n, j in 1:p], sum(x[i,j,k] for k in 1:nbR)==1)
    @constraint(m, [i in 1:n*p, j in 1:n*p; i!=j], sum(y[i,j,k] for k in 1:nbR) <= 1)

    # 3 the number of palisade of a case is equal to the indicated value
    @constraint(m, [i in 2:n-1, j in 2:p-1; t[i,j]!=0], sum(y[(i-1)*(p)+j,(i-1)*(p)+j+1,k] + y[(i-1)*(p)+j,(i-1)*(p)+j-1,k] + y[(i-1)*(p)+j,(i-2)*p+j,k] + y[(i-1)*(p-1)+j,i*(p)+j,k] for k in 1:nbR) == t[i,j])   
        #each side
    @constraint(m, [j in 2:p-1; t[1,j]!=0], sum(y[j,j+1,k] + y[j,j-1,k] + y[j,p+j,k] for k in 1:nbR) == t[1,j] - 1)
    @constraint(m, [j in 2:p-1; t[n,j]!=0], sum(y[n*(p-1)+j,n*(p-1)+j+1,k] + y[n*(p-1)+j,n*(p-1)+j-1,k] + y[n*(p-1)+j,n*(p-2)+j,k] for k in 1:nbR) == t[n,j] - 1)

    @constraint(m, [i in 2:n-1; t[i,1]!=0], sum(y[(i-1)*(p)+1,(i-1)*(p)+2,k] + y[(i-1)*(p)+1,(i-2)*p+1,k] + y[(i-1)*p+1,(i)*p+1,k] for k in 1:nbR) == t[i,1] - 1)
    @constraint(m, [i in 2:n-2; t[i,p]!=0], sum(y[(i-1)*(p)+p,(i-1)*p+p-1,k] + y[(i-1)*p+p,(i-2)*p+p,k] + y[(i-1)*(p)+p,(i)*p+p,k] for k in 1:nbR) == t[i,p] - 1)
        #each angles
    if t[1,1]!=0
        @constraint(m, sum(y[1,2,k] + y[1,p+1,k] for k in 1:nbR) == t[1,1] - 2)
    end
    if t[n,p]!=0
        @constraint(m, sum(y[n*p,n*(p-1),k] + y[n*p,n*p-1,k] for k in 1:nbR)== t[n,p] - 2)
    end
    if t[1,p]!=0
        @constraint(m, sum(y[p,p-1,k] + y[p,2*p,k] for k in 1:nbR) == t[1,p] - 2)
    end
    if t[n,1]!=0
        @constraint(m, sum(y[n*(p-1)+1,n*(p-1)+2,k] + y[n*(p-1)+1,n*(p-2)+1,k] for k in 1:nbR) == t[n,1] - 2)
    end

    #No palisade between 2 case from opposite side 
    @constraint(m, [i in 2:n-1], sum(y[i*(p)+1, i*(p),k] for k in 1:nbR)==0)
    @constraint(m, [i in 2:n-1], sum(y[i*(p), i*(p)+1,k] for k in 1:nbR)==0)

    # there exist a palisade between case i and j if there are not in the same region

    # a case of a region always has at least one neighboord which belong to the same region
    @constraint(m, [i in 2:n-1, j in 2:p-1, k in 1:nbR; sizeR>1],  x[i,j+1,k] + x[i,j-1,k] + x[i+1,j,k] + x[i-1,j,k] >= x[i,j,k])
    @constraint(m, [i in 3:n-2, j in 3:p-2, k in 1:nbR; sizeR>=5],  x[i,j+1,k] + x[i,j-1,k] + x[i+1,j,k] + x[i-1,j,k] + x[i,j+2,k] + x[i,j-2,k] + x[i+2,j,k] + x[i-2,j,k] + x[i+1,j+1,k] + x[i-1,j-1,k] + x[i-1,j+1,k] + x[i+1,j-1,k]>= x[i,j,k]*2)
    
    @constraint(m, [j in 3:p-2, k in 1:nbR; sizeR>1],  x[2,j+1,k] + x[2,j-1,k] + x[3,j,k] + x[2,j-2,k] + x[2,j+2,k] + x[3,j-1,k] + x[3,j+1,k] + x[4,j,k] + x[1,j,k] + x[1,j-1,k] + x[1,j+1,k]>= x[2,j,k]*2)
    @constraint(m, [j in 3:p-2, k in 1:nbR; sizeR>1],  x[n-1,j+1,k] + x[n-1,j-1,k] + x[n-2,j,k] + x[n-1,j-2,k] + x[n-1,j+2,k] + x[n-2,j-1,k] + x[n-2,j+1,k] + x[n-3,j,k] + x[n,j,k] + x[n,j-1,k] + x[n,j+1,k]>= x[n-1,j,k]*2)
        #each side
    @constraint(m, [j in 2:p-1, k in 1:nbR; sizeR>1],  x[1,j+1,k] + x[1,j-1,k] + x[2,j,k] >= x[1,j,k])
    @constraint(m, [j in 3:p-2, k in 1:nbR; sizeR>1],  x[1,j+1,k] + x[1,j-1,k] + x[2,j,k] + x[1,j-2,k] + x[1,j+2,k] + x[2,j-1,k] + x[2,j+1,k] + x[3,j,k]>= x[1,j,k]*2)
    @constraint(m, [j in 2:p-1, k in 1:nbR; sizeR>1],  x[n,j+1,k] + x[n,j-1,k] + x[n-1,j,k] >= x[n,j,k])
    @constraint(m, [j in 3:p-2, k in 1:nbR; sizeR>1],  x[n,j+1,k] + x[n,j-1,k] + x[n-1,j,k] + x[n,j+2,k] + x[n,j-2,k] + x[n-1,j+1,k] + x[n-1,j-1,k] + x[n-2,j,k]>= x[n,j,k]*2)
    @constraint(m, [i in 2:n-1, k in 1:nbR; sizeR>1],  x[i+1,1,k] + x[i-1,1,k] + x[i,2,k] >= x[i,1,k])
    @constraint(m, [i in 3:n-2, k in 1:nbR; sizeR>1],  x[i+1,1,k] + x[i-1,1,k] + x[i,2,k] + x[i+2,1,k] + x[i-2,1,k] + x[i,3,k] + x[i+1,2,k] + x[i-1,2,k] >= x[i,1,k]*2)
    @constraint(m, [i in 2:n-1, k in 1:nbR; sizeR>1],  x[i+1,p,k] + x[i-1,p,k] + x[i,p-1,k] >= x[i,p,k])
    @constraint(m, [i in 3:n-2, k in 1:nbR; sizeR>1],  x[i+1,p,k] + x[i-1,p,k] + x[i,p-1,k] + x[i-2,p,k] + x[i+2,p,k] + x[i,p-2,k] + x[i-1,p-1,k] + x[i+1,p-1,k]>= x[i,p,k]*2)
        #each angles
    @constraint(m,[k in 1:nbR; sizeR>1], x[1,2,k] + x[2,1,k] >= x[1,1,k])
    @constraint(m,[k in 1:nbR; sizeR>1], x[n,p-1,k] + x[n-1,p,k] >= x[n,p,k])
    @constraint(m,[k in 1:nbR; sizeR>1], x[n,2,k] + x[n-1,1,k] >= x[n,1,k])
    @constraint(m,[k in 1:nbR; sizeR>1], x[1,p-1,k] + x[2,p,k] >= x[1,p,k])


    for i in 1:n
        for j in 1:p
            @constraint(m, [a in 1:n, b in 1:p, k in 1:nbR; a!=i && b!=j], x[i,j,k]*x[a,b,k]*(abs(i-a)+abs(j-b))<= nbR-1 )
        end
    end
    ######################################################################################################
    #@constraint(m, [i in 1:n, j in 1:p-1, k in 1:nbR], y[(i-1)*p+j,(i-1)*p+j+1,k] <=x[i,j,k])
    #@constraint(m, [i in 1:n, j in 1:p-1, k in 1:nbR], y[(i-1)*p+j,(i-1)*p+j+1,k] <=x[i,j+1,k])

    #@constraint(m, [i in 1:n, j in 1:p-1, k in 1:nbR], y[(i-1)*p+j,(i-1)*p+j+1,k] <= 1 - x[i,j,k]*x[i,j+1,k])
    @constraint(m, [i in 1:n, j in 1:p-1], sum(y[(i-1)*p+j,(i-1)*p+j+1,k] + x[i,j,k]*x[i,j+1,k] for k in 1:nbR) == 1)
    @constraint(m, [i in 1:n-1, j in 1:p], sum(y[(i-1)*p+j,(i)*p+j,k] + x[i,j,k]*x[i+1,j,k] for k in 1:nbR) == 1)
    #@constraint(m, [i in 1:n-1, j in 1:p, k in 1:nbR], y[(i-1)*p+j,(i)*p+j,k] == 1 - x[i,j,k]*x[i+1,j,k])
    
    #@constraint(m, [i in 2:n-1, j in 2:p-1], y[i*(n-1)+j,i*(n-1)+j+1]==y[i*(n-1)+j+1,i*(n-1)+j] )
    
    # Start a chronometer
    start = time()

    # Solve the model
    optimize!(m)
    for i in 1:n
        for j in 1:p
            for k in 1:nbR
                if JuMP.value(x[i,j,k])> TOL
                    print(k," ")
                end
            end
        end
        println()
    end
    a=2
    b=4
    println((a-1)*(n)+b, " = ", t[a,b])
    cpt=0
    for k in 1:nbR
        cpt =cpt +JuMP.value(y[(a-1)*(n)+b,(a-1)*n+b+1,k])
        println(JuMP.value(y[(a-1)*(n)+b,(a)*n+b,k]))
        cpt+=JuMP.value(y[(a-1)*(n)+b,(a-1)*n+b-1,k])
        cpt+=JuMP.value(y[(a-1)*(n)+b,(a-2)*n+b,k])
        cpt+=JuMP.value(y[(a-1)*(n)+b,(a)*n+b,k])
    end
    println("cpt = ", cpt)
    # Return:
    # 1 - true if an optimum is found
    # 2 - the resolution time
    return JuMP.primal_status(m) == JuMP.MathOptInterface.FEASIBLE_POINT, time() - start, x,y
end

"""
Heuristically solve an instance
"""
function heuristicSolve()

    # TODO
    println("In file resolution.jl, in method heuristicSolve(), TODO: fix input and output, define the model")
    
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
    resolutionMethod = ["cplex"]
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
        readInputFile(dataFolder * file)

        # TODO
        println("In file resolution.jl, in method solveDataSet(), TODO: read value returned by readInputFile()")
        
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
                    
                    # TODO 
                    println("In file resolution.jl, in method solveDataSet(), TODO: fix cplexSolve() arguments and returned values")
                    
                    # Solve it and get the results
                    isOptimal, resolutionTime = cplexSolve()
                    
                    # If a solution is found, write it
                    if isOptimal
                        # TODO
                        println("In file resolution.jl, in method solveDataSet(), TODO: write cplex solution in fout") 
                    end

                # If the method is one of the heuristics
                else
                    
                    isSolved = false

                    # Start a chronometer 
                    startingTime = time()
                    
                    # While the grid is not solved and less than 100 seconds are elapsed
                    while !isOptimal && resolutionTime < 100
                        
                        # TODO 
                        println("In file resolution.jl, in method solveDataSet(), TODO: fix heuristicSolve() arguments and returned values")
                        
                        # Solve it and get the results
                        isOptimal, resolutionTime = heuristicSolve()

                        # Stop the chronometer
                        resolutionTime = time() - startingTime
                        
                    end

                    # Write the solution (if any)
                    if isOptimal

                        # TODO
                        println("In file resolution.jl, in method solveDataSet(), TODO: write the heuristic solution in fout")
                        
                    end 
                end

                println(fout, "solveTime = ", resolutionTime) 
                println(fout, "isOptimal = ", isOptimal)
                
                # TODO
                println("In file resolution.jl, in method solveDataSet(), TODO: write the solution in fout") 
                close(fout)
            end


            # Display the results obtained with the method on the current instance
            include(outputFile)
            println(resolutionMethod[methodId], " optimal: ", isOptimal)
            println(resolutionMethod[methodId], " time: " * string(round(solveTime, sigdigits=2)) * "s\n")
        end         
    end 
end