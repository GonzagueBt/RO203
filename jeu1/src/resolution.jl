# This file contains methods to solve an instance (heuristically or with CPLEX)
using CPLEX

include("generation.jl")

TOL = 0.00001

"""
Solve an instance with CPLEX
"""
function cplexSolve(y::Vector{}, k::Vector{}, a::Array{})
    n = size(y,1)
    p = size(k,1)
    nbA = size(a,1)

    # Create the model
    m = Model(CPLEX.Optimizer)

    ########### Variables ########### 
    # x[i, j] = 1 if cell i,j is a tent
    @variable(m, x[1:n, 1:p], Bin)


    ########### constraints ###########
    # 1 - Set the fixed value in the grid
    for i in 1:size(a,1)
        @constraint(m, x[a[i,1],a[i,2]]== 0)
    end

    # 2 - each column contain the indicate value of tents
    @constraint(m, [i in 1:n], sum(x[i,j] for j in 1:p)==k[i])

    # 3 - each line contain the indicate value of tents
    @constraint(m, [j in 1:p], sum(x[i,j] for i in 1:n)==y[j])

    # 4 - the number of tents is the number of tree
    @constraint(m, sum(x[i,j] for i in 1:n for j in 1:p)==nbA)
    
    # 4 - each tree have a tent next to it
    for i in 1:nbA
        if a[i,1]>=2 && a[i,1]<=n-1 && a[i,2]>=2 && a[i,2]<=p-1
            @constraint(m, x[a[i,1]+1,a[i,2]] + x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]+1] + x[a[i,1],a[i,2]-1]>=1)
        end
        #each sides
        if a[i,1]==1 && a[i,2]>=2 && a[i,2]<=p-1
            @constraint(m, x[a[i,1]+1,a[i,2]] + x[a[i,1],a[i,2]+1] + x[a[i,1],a[i,2]-1]>=1)
        end
        if a[i,1]==n && a[i,2]>=2 && a[i,2]<=p-1
            @constraint(m, x[n-1,a[i,2]] + x[n,a[i,2]+1] + x[n,a[i,2]-1]>=1)
        end
        if a[i,1]>=2 && a[i,1]<=n-1 && a[i,2]==1
            @constraint(m, x[a[i,1]+1,1] + x[a[i,1]-1,1] + x[a[i,1],2] >=1)
        end
        if a[i,1]>=2 && a[i,1]<=n-1 && a[i,2]==p
            @constraint(m, x[a[i,1]+1,p] + x[a[i,1]-1,p] + x[a[i,1],p-1] >=1)
        end
        #each angles
        if a[i,1]==1 && a[i,2]==1
            @constraint(m, x[2,1] + x[1,2]>=1)
        end
        if a[i,1]==1 && a[i,2]==p
            @constraint(m, x[2,p] + x[1,p-1]>=1)
        end
        if a[i,1]==n && a[i,2]==p
            @constraint(m, x[n-1,p] + x[n,p-1]>=1)
        end
        if a[i,1]==n && a[i,2]==1
            @constraint(m, x[n-1,1] + x[n,2] >=1)
        end
    end

    # 2 tents can not be next to each other or in diag
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i+1,j] + x[i+1,j-1]<=1)
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i-1,j] + x[i-1,j+1]<=1)
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i,j+1] + x[i+1,j+1]<=1)
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i,j-1] + x[i-1,j-1] <=1)
        #each side
    @constraint(m, [j in 2:p-1], x[1,j] + x[2,j] + x[1,j-1]<=1)
    @constraint(m, [j in 2:p-1], x[1,j] + x[1,j+1] + x[2,j+1]<=1)
    @constraint(m, [j in 2:p-1], x[1,j] + x[2,j-1]<=1)

    @constraint(m, [j in 2:p-1], x[n,j] + x[n-1,j] + + x[n-1,j+1]<=1)
    @constraint(m, [j in 2:p-1], x[n,j] + x[n,j+1]<=1)
    @constraint(m, [j in 2:p-1], x[n,j] + x[n,j-1] + x[n-1,j-1]<=1)

    @constraint(m, [i in 2:n-1], x[i,1] + x[i,2] + x[i+1,2]<=1)
    @constraint(m, [i in 2:n-1], x[i,1] + x[i+1,1]<=1)
    @constraint(m, [i in 2:n-1], x[i,1] + x[i-1,1] + x[i-1,2]<=1)
    
    @constraint(m, [i in 2:n-1], x[i,p] + x[i,p-1] + x[i-1,p-1]<=1)
    @constraint(m, [i in 2:n-1], x[i,p] + x[i+1,p] + x[i+1,p-1]<=1)
    @constraint(m, [i in 2:n-1], x[i,p] + x[i-1,p] <=1)
        # each angles
    @constraint(m, x[1,1] + x[1,2] + x[2,2]<=1)
    @constraint(m, x[1,1] + x[2,1] + x[2,2]<=1)
    @constraint(m, x[1,p] + x[1,p-1] + x[2,p-1]<=1)
    @constraint(m, x[1,p] + x[2,p] + x[2,p-1]<=1)
    @constraint(m, x[n,1] + x[n,2] + x[n-1,2]<=1)
    @constraint(m, x[n,1] + x[n-1,1] + x[n-1,2]<=1)
    @constraint(m, x[n,p] + x[n,p-1] + x[n-1,p-1]<=1)
    @constraint(m, x[n,p] + x[n-1,p] + x[n-1,p-1]<=1)

    @objective(m, Min, 1)
    # Start a chronometer
    start = time()

    # Solve the model
    optimize!(m)
    
    tps= time() - start
    # Return:
    # 1 - true if an optimum is found
    # 2 - the resolution time
    # 3 - the binary variable x
    return JuMP.primal_status(m) == JuMP.MathOptInterface.FEASIBLE_POINT, tps, x
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
        t,y,k,a = readInputFile(dataFolder * file)
        
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
                    isOptimal, resolutionTime, x = cplexSolve(y,k,a)
                    
                    # If a solution is found, write it
                    if isOptimal
                        n = size(t,1)
                        m = size(t,2)
                        println(fout, "t = [")
                        #print(fout,string("-"))
                        #for i in 1:m
                        #    print(fout,string("-"))
                        #end
                        #println(fout,string("-"))
                        for i in 1:n
                            #print(fout,string("|"))
                            print(fout,"[ ")
                            for j in 1:m
                                if t[i,j] == 1
                                    print(fout,string(1)*" ")
                                elseif JuMP.value(x[i,j]) > TOL
                                    print(fout,string(2)*" ")
                                else
                                    print(fout,string(0)*" ")
                                end
                            end
                            #print(fout,string("|"))
                            println(fout,string(k[i])*"];")
                        end
                        #print(fout,string("-"))
                        #for i in 1:m
                        #    print(fout,string("-"))
                        #end
                        #println(fout,string("-"))
                        print(fout,"[ ")
                        for i in 1:m
                            print(fout,string(y[i])*" ")
                        end
                        println(fout," "*string(0)*"]")
                        println(fout,"]")
                    end
                end
                println(fout," ")
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
