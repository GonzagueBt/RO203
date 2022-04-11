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
    #constraint(m, [i in 1:nbA , a[i,1]>1 && a[i,1]<n && a[i,2]>1 && a[i,2]<p], x[a[i,1]+1,a[i,2]] + x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]+1] + x[a[i,1],a[i,2]-1]>=1)
        # each side
    #constraint(m, [i in 1:size(a,1); a[i,1]==1 && a[i,2]>1 && a[i,2]<p], x[a[i,1]+1,a[i,2]] + x[a[i,1],a[i,2]+1] + x[a[i,1],a[i,2]-1]>=1)
    #constraint(m, [i in 1:size(a,1); a[i,1]==n && a[i,2]>1 && a[i,2]<p], x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]+1] + x[a[i,1],a[i,2]-1]>=1)
    #constraint(m, [i in 1:size(a,1); a[i,1]>1 && a[i,1]<n && a[i,2]==1], x[a[i,1]+1,a[i,2]] + x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]+1] >=1)
    #constraint(m, [i in 1:size(a,1); a[i,1]>1 && a[i,1]<n && a[i,2]==p], x[a[i,1]+1,a[i,2]] + x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]-1] >=1)
        # each angles


    for i in 1:nbA
        #if a[i,1]>=2 && a[i,1]<=n-1 && a[i,2]>=2 && a[i,2]<=p-1
        #    constraint(m, x[a[i,1]+1,a[i,2]] + x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]+1] + x[a[i,1],a[i,2]-1]>=1)
        #each sides
        if a[i,1]==1 && a[i,2]>=2 && a[i,2]<=p-1
            constraint(m, x[a[i,1]+1,a[i,2]] + x[a[i,1],a[i,2]+1] + x[a[i,1],a[i,2]-1]>=1)
        elseif a[i,1]==n && a[i,2]>=2 && a[i,2]<=p-1
            constraint(m, x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]+1] + x[a[i,1],a[i,2]-1]>=1)

        #elseif a[i,1]>=2 && a[i,1]<=n-1 && a[i,2]==1
        #    constraint(m, x[a[i,1]+1,1] + x[a[i,1]-1,1] + x[a[i,1],2] >=1)
        #elseif a[i,1]>=2 && a[i,1]<=n-1 && a[i,2]==p
        #    constraint(m, x[a[i,1]+1,a[i,2]] + x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]-1] >=1)
        #each angles
        elseif a[i,1]==1 && a[i,2]==1
            constraint(m, x[2,1] + x[1,2]>=1)
        elseif a[i,1]==1 && a[i,2]==p
            constraint(m, x[2,p] + x[1,p-1]>=1)
        elseif a[i,1]==n && a[i,2]==p
            constraint(m, x[n-1,p] + x[n,p-1]>=1)
        #elseif a[i,1]==n && a[i,2]==1
        #    constraint(m, x[n-1,1] + x[n,2]>=1)
        end
    end
    #constraint(m, [i in 1:size(a,1); a[i,1]==1 && a[i,2]==p], x[a[i,1]+1,a[i,2]] + x[a[i,1],a[i,2]-1]>=1)
    #constraint(m, [i in 1:size(a,1); a[i,1]==n && a[i,2]==p], x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]-1]>=1)
    #constraint(m, [i in 1:size(a,1); a[i,1]==n && a[i,2]==1], x[a[i,1]-1,a[i,2]] + x[a[i,1],a[i,2]+1]>=1)

    # 2 tents can not be next to each other or in diag
    #@constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i-1,j]<=1) ########
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i+1,j]<=1)
    #@constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i,j-1]<=1) ########
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i,j+1]<=1)
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i-1,j-1]<=1)
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i-1,j+1]<=1)
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i+1,j-1]<=1)
    @constraint(m, [i in 2:n-1, j in 2:p-1], x[i,j] + x[i+1,j+1]<=1)
        #each side
    @constraint(m, [j in 2:p-1], x[1,j] + x[2,j]<=1)
    @constraint(m, [j in 2:p-1], x[1,j] + x[1,j+1]<=1)
    @constraint(m, [j in 2:p-1], x[1,j] + x[1,j-1]<=1)
    @constraint(m, [j in 2:p-1], x[1,j] + x[2,j+1]<=1)
    @constraint(m, [j in 2:p-1], x[1,j] + x[2,j-1]<=1)

    @constraint(m, [j in 2:p-1], x[n,j] + x[n-1,j]<=1)
    @constraint(m, [j in 2:p-1], x[n,j] + x[n,j+1]<=1)
    @constraint(m, [j in 2:p-1], x[n,j] + x[n-1,j+1]<=1)
    @constraint(m, [j in 2:p-1], x[n,j] + x[n-1,j-1]<=1)

    @constraint(m, [i in 2:n-1], x[i,1] + x[i,2]<=1)
    @constraint(m, [i in 2:n-1], x[i,1] + x[i+1,1]<=1)
    @constraint(m, [i in 2:n-1], x[i,1] + x[i-1,1]<=1)
    @constraint(m, [i in 2:n-1], x[i,1] + x[i-1,2]<=1)
    @constraint(m, [i in 2:n-1], x[i,1] + x[i+1,2]<=1)
    
    @constraint(m, [i in 2:n-1], x[i,p] + x[i,p-1]<=1)
    @constraint(m, [i in 2:n-1], x[i,p] + x[i+1,p]<=1)
    @constraint(m, [i in 2:n-1], x[i,p] + x[i-1,p-1]<=1)
    @constraint(m, [i in 2:n-1], x[i,p] + x[i+1,p-1]<=1)

        # each angles
    @constraint(m, x[1,1] + x[1,2] + x[2,1] + x[2,2]<=1)
    @constraint(m, x[1,1] + x[2,1] + x[2,2]<=1)
    @constraint(m, x[1,p] + x[1,p-1] + x[2,p-1]<=1)
    @constraint(m, x[1,p] + x[2,p] + x[2,p-1]<=1)
    @constraint(m, x[n,1] + x[n,2] + x[n-1,2]<=1)
    @constraint(m, x[n,1] + x[n-1,1] + x[n-1,2]<=1)
    @constraint(m, x[n,p] + x[n,p-1] + x[n-1,p-1]<=1)
    @constraint(m, x[n,p] + x[n-1,p] + x[n-1,p-1]<=1)

    # TODO
    println("In file resolution.jl, in method cplexSolve(), TODO: fix input and output, define the model")

    # Start a chronometer
    start = time()

    # Solve the model
    optimize!(m)
    
    tps= time() - start
    # Return:
    # 1 - true if an optimum is found
    # 2 - the resolution time

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
