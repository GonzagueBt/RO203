# This file contains methods to generate a data set of instances (i.e., palisade)
include("io.jl")

"""
Generate an n*n grid with a given density

Argument
- x,y: sizes of the grid
- sizeR : size of the regions
"""
function generateInstance(x::Int64, y::Int64, sizeR::Int64)

    density = 0.3
    # Nb of numbers displayed
    n = trunc(Int,density*x*y)

    # Matrix representing regions
    grid = zeros(Int64, x, y)

    # Matrix with numbers of edges
    nb = zeros(Int64, x, y)

    # Nb of regions => one number per region, displayed on every square of the region
    nbR = trunc(Int,(x*y)/sizeR)
    #println(nbR)

    # First, trivial valid tiling
    for k in 1:nbR
        for p in 1:sizeR
            if mod((k-1)*sizeR+p,y)!=0
                grid[trunc(Int,ceil(((k-1)sizeR+p)/y)),mod((k-1)*sizeR+p,y)]=k
            else
                grid[trunc(Int,ceil(((k-1)sizeR+p)/y)),y]=k
            end
        end
    end
    #println(grid)

    # Second, randomly modify tiling each times, while number of modifications wished not reached

    #Number of modifications
    modif = trunc(Int, density*x*y)

    k=0

    while (k<modif)
        a = rand(1:x)
        b = rand(1:y)
        println("a=",a)
        println("b=",b)
        println("k=",k)
        println(grid)

        # Area nb "val" in coords a,b
        val=grid[a,b]

        # Squares if in a corner, on an edge, or not
        if (a!=1 && a!= x && b!= 1 && b!=y)
            # Look at all 4 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made                            
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)                       
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i-1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i+1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j-1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j+1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end

            elseif (grid[a+1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b-1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b+1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end



        elseif (a==1 && a!= x && b!= 1 && b!=y) # edge 1
            # Look at all 3 neighboring squares and find another region to exange tiles wit            
            if (grid[a+1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b-1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b+1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end


            
        elseif (a!=1 && a== x && b!= 1 && b!=y) # edge 2
            # Look at all 3 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made                            
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)                       
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i-1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i+1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j-1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j+1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end

            elseif (grid[a,b-1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b+1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end


            
        elseif (a!=1 && a!= x && b== 1 && b!=y) # edge 3
            # Look at all 3 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made                            
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)                       
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i-1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i+1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j-1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j+1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end

            elseif (grid[a+1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b+1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end


            
        elseif (a!=1 && a!= x && b!= 1 && b==y) # edge 4
            # Look at all 3 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made                            
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)                       
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i-1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i+1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j-1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j+1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end

            elseif (grid[a+1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b-1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end



            
        elseif (a==1 && a!= x && b== 1 && b!=y) # corner 1
            # Look at all 2 neighboring squares and find another region to exange tiles with
            if (grid[a+1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b+1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end


            
        elseif (a==1 && a!= x && b!= 1 && b==y) # corner 2
            # Look at all 2 neighboring squares and find another region to exange tiles with
            if (grid[a+1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a+1,b]
                                    grid[a,b]=grid[a+1,b]
                                    grid[a+1,b]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a+1,b]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            elseif (grid[a,b-1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end



            
        elseif (a!=1 && a== x && b== 1 && b!=y) # corner 3
            # Look at all 2 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made                            
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)                       
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i-1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i+1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j-1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j+1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end

            elseif (grid[a,b+1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b+1]
                                    grid[a,b]=grid[a,b+1]
                                    grid[a,b+1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b+1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end



            
        elseif (a!=1 && a== x && b!= 1 && b==y) # corner 4
            # Look at all 2 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made                            
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)                       
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i-1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i+1,j]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j-1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a,b]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        grid[i,j]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid)
                                            grid[a-1,b]=grid[a,b]
                                            grid[i,j]=grid[a,b]
                                            grid[i,j+1]=val
                                            grid[a,b]=val
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end

            elseif (grid[a,b-1]!=val)
                for i in 1:x
                    for j in 1:y
                        temp=k
                        while (k!=temp+1) # while no exchange has been made 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (grid[i-1,j]==val)                       
                                    grid[i-1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i-1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i+1,j]==val)
                                    grid[i+1,j]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i+1,j]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j-1]==val)
                                    grid[i,j-1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j-1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                elseif (grid[i,j+1]==val)
                                    grid[i,j+1]=grid[a,b-1]
                                    grid[a,b]=grid[a,b-1]
                                    grid[a,b-1]=val
                                    grid[i,j]=val
                                    k+=1
                                    # Make sure this results in a configuration where the squares of each
                                    # tile are still connected to each other (otherwise undo the modification).
                                    if !isGridValid(grid)
                                        grid[a,b-1]=grid[a,b]
                                        grid[i,j]=grid[a,b]
                                        grid[i,j+1]=val
                                        grid[a,b]=val
                                        k-=1
                                    end
                                else
                                end
                            end
                        end
                    end
                end

            else
            end
  
        end

    end

    println(grid)






    return grid
end 

"""
Check that each tile is still connected to another of its region

Argument
- x: the grid to check
"""

function isGridValid(x::Matrix{Int64})
    (x,y)=size(x)
    valid=true

    for i in 1:x
        for j in 1:y
            s=0
            val = grid[i,j]
            if (i!=1 && i!= x && j!= 1 && j!=y)
                if grid[i-1,j]==val
                    s+=1
                end
                if grid[i,j-1]==val
                    s+=1
                end
                if grid[i,j+1]==val
                    s+=1
                end
                if grid[i+1,j]==val
                    s+=1
                end
            elseif (i==1 && i!= x && j!= 1 && j!=y) # edge 1
                if grid[i,j-1]==val
                    s+=1
                end
                if grid[i,j+1]==val
                    s+=1
                end
                if grid[i+1,j]==val
                    s+=1
                end
            elseif (i!=1 && i== x && j!= 1 && j!=y) # edge 2
                if grid[i-1,j]==val
                    s+=1
                end
                if grid[i,j-1]==val
                    s+=1
                end
                if grid[i,j+1]==val
                    s+=1
                end     
            elseif (i!=1 && i!= x && j== 1 && j!=y) # edge 3
                if grid[i-1,j]==val
                    s+=1
                end
                if grid[i,j+1]==val
                    s+=1
                end
                if grid[i+1,j]==val
                    s+=1
                end                
            elseif (i!=1 && i!= x && j!= 1 && j==y) # edge 4
                if grid[i-1,j]==val
                    s+=1
                end
                if grid[i,j-1]==val
                    s+=1
                end
                if grid[i+1,j]==val
                    s+=1
                end                
            elseif (i==1 && i!= x && j== 1 && j!=y) # corner 1
                if grid[i,j+1]==val
                    s+=1
                end
                if grid[i+1,j]==val
                    s+=1
                end                
            elseif (i==1 && i!= x && j!= 1 && j==y) # corner 2
                if grid[i,j-1]==val
                    s+=1
                end
                if grid[i+1,j]==val
                    s+=1
                end                
            elseif (i!=1 && i== x && j== 1 && j!=y) # corner 3
                if grid[i-1,j]==val
                    s+=1
                end
                if grid[i,j+1]==val
                    s+=1
                end             
            elseif (i!=1 && i== x && b!= 1 && b==y) # corner 4
                if grid[i-1,j]==val
                    s+=1
                end
                if grid[i,j-1]==val
                    s+=1
                end             
            end
            if s==0
                valid=false
            end                
                
        end

    end

    return valid
end


"""
Generate all the instances

Remark: a grid is generated only if the corresponding output file does not already exist
"""
function generateDataSet()
    
    # TODO
    println("In file generation.jl, in method generateDataSet(), TODO: generate an instance")
    
end



