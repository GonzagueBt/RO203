# This file contains methods to solve an instance (heuristically or with CPLEX)
using CPLEX

include("generation.jl")

TOL = 0.00001

"""
Solve an instance with CPLEX
"""
function cplexSolve(n::Int64, p::Int64, y::Array{Int, 2})

    nbRec = size(y,1)

    # Create the model
    m = Model(CPLEX.Optimizer)

    ########### Variables ########### 

    # x[i, k] = 1 if cell i is in rectangle k
    @variable(m, x[1:n, 1:p, 1:nbRec], Bin)


    ########### constraints ###########
    # 1 - Set the fixed value in the grid
    for i in 1:nbRec
        @constraint(m, x[y[i,2], y[i,3],i] == 1)
    end

    # 2 - a case belong to only on rectangle
    @constraint(m, [i in 1:n, j in 1:p], sum(x[i,j,k] for k in 1:nbRec)==1)

    # 3 - nb of case of one rectangle is respected and 
    @constraint(m, [k in 1:nbRec], sum(x[i,j,k] for i in 1:n for j in 1:p)==y[k,1])

    # 4 - rectangles with a number odd of case are juste lines
    #@constraint(m, [k in 1:nbRec, i in 1:n-1, j in 1:p-1; rem(y[k,1],2)==1 || y[k,1]==2], x[i,j,k]+x[i+1,j,k]+x[i,j+1,k] <= 2)
    #@constraint(m, [k in 1:nbRec, i in 1:n-1, j in 2:p; rem(y[k,1],2)==1 || y[k,1]==2], x[i,j,k]+x[i+1,j,k]+x[i,j-1,k] <= 2)
    #@constraint(m, [k in 1:nbRec, i in 2:n, j in 1:p-1; rem(y[k,1],2)==1 || y[k,1]==2], x[i,j,k]+x[i-1,j,k]+x[i,j+1,k] <= 2)
    #@constraint(m, [k in 1:nbRec, i in 2:n, j in 2:p; rem(y[k,1],2)==1 || y[k,1]==2], x[i,j,k]+x[i-1,j,k]+x[i,j-1,k] <= 2)
    

    # 5 - cases of a same rectangle are grouped (a case i of rect k have a case j also from rect k next to it)
    #@constraint(m, [k in 1:nbRec, i in 2:n-1, j in 2:p-1; y[k,1]!=2], x[i,j,k]+x[i+1,j,k]+x[i-1,j,k]+x[i,j+1,k]+x[i,j-1,k] >= 2)

    # 6 - cas of an even rectangle must has at least 2 neighboords of the its rectangle
    #@constraint(m, [k in 1:nbRec, i in 2:n-1, j in 2:p-1; rem(y[k,1],4)==0 && x[i,j,k]==1],x[i+1,j,k]+x[i-1,j,k]+x[i,j+1,k]+x[i,j-1,k] >= 2)
   
    @constraint(m, [k in 1:nbRec, j in 2:p-1; rem(y[k,1],4)==0 && x[1,j,k]==1], x[2,j,k]+x[1,j+1,k]+x[1,j-1,k] >= 1)
    #@constraint(m, [k in 1:nbRec, j in 2:p-1; rem(y[k,1],4)==0 && x[1,j,k]==1], x[2,j,k]+x[1,j+1,k]+x[1,j-1,k] >= 1)
    #@constraint(m, [k in 1:nbRec, j in 2:p-1; rem(y[k,1],4)==0 && x[n,j,k]==1], x[n-1,j,k]+x[n,j+1,k]+x[n,j-1,k] >= 1)
    #@constraint(m, [k in 1:nbRec, i in 2:n-1; rem(y[k,1],4)==0 && x[i,1,k]==1], x[i-1,1,k]+x[i+1,1,k]+x[i,2,k] >= 1)
    #@constraint(m, [k in 1:nbRec, i in 2:n-1; rem(y[k,1],4)==0 && x[i,p,k]==1], x[i-1,p,k]+x[i+1,p,k]+x[i,p-1,k] >= 1)
    
    @constraint(m, [k in 1:nbRec, y[k,1]!=2],  x[1,2,k]+x[2,1,k] >= x[1,1,k])
    #@constraint(m, [k in 1:nbRec, rem(y[k,1],2)==0 && y[k,1]!=2 && x[n,p,k]==1], x[n,p-1,k]+x[n-1,p,k] >= 1)
    #@constraint(m, [k in 1:nbRec, rem(y[k,1],2)==0 && y[k,1]!=2 && x[n,1,k]==1], x[n,2,k]+x[n-1,1,k] >= 1)
    #@constraint(m, [k in 1:nbRec, rem(y[k,1],2)==0 && y[k,1]!=2 && x[1,p,k]==1], x[1,p-1,k]+x[2,p,k] >= 1)
    
    #@constraint(m, [k in 1:nbRec, i in 1:n-1, j in 1:p-1; rem(y[k,1],4)==0], x[i,j,k]+x[i+1,j+1,k]==x[i+1,j,k]+x[i,j+1,k]) 
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
    vx = JuMP.value.(x)
    t = Array{Int64}(undef, n,p)
    for i in 1:n
        for j in 1:p
            for k in 1:nbRec
                if JuMP.value(x[i,j,k])==1
                    t[i,j] = k
                    break
                end
            end
        end 
    end
    println(t)
    return JuMP.primal_status(m) == JuMP.MathOptInterface.FEASIBLE_POINT, tps, t
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
