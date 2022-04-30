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
    n = trunc(Int,density*x*y)+2

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
            if mod(trunc(Int,ceil(((k-1)sizeR+p)/y)),2)==1
                if mod((k-1)*sizeR+p,y)!=0
                    grid[trunc(Int,ceil(((k-1)sizeR+p)/y)),mod((k-1)*sizeR+p,y)]=k
                else
                    grid[trunc(Int,ceil(((k-1)sizeR+p)/y)),y]=k
                end
            else
                if mod((k-1)*sizeR+p,y)!=0
                    grid[trunc(Int,ceil(((k-1)sizeR+p)/y)),y-mod((k-1)*sizeR+p,y)+1]=k
                else
                    grid[trunc(Int,ceil(((k-1)sizeR+p)/y)),1]=k
                end
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
        #println("a=",a)
        #println("b=",b)
        #println("k=",k)
        #println(grid)

        # Area nb "val" in coords a,b
        val=grid[a,b]

        # Squares if in a corner, on an edge, or not
        if (a!=1 && a!= x && b!= 1 && b!=y)
            # Look at all 4 neighboring squares and find another region to exange tiles with
            temp=k
            if (grid[a-1,b]!=val && k!=temp+1)                
                for i in 1:x                   
                    for j in 1:y                        
                        if (i!=a-1 || j!=b)                                  
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)  
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i-1,j]
                                            grid[i-1,j]=val                                           
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end
            end
            if (grid[a+1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a+1 || j!=b)                 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)         
                                        grid[i-1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b-1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y    
                        if (i!=a-1 || j!=b)                  
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)       
                                        grid[i-1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b+1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a || j!=b+1)                   
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)          
                                        grid[i-1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i-1,j]
                                            grid[i-1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

            end

        elseif (a==1 && a!= x && b!= 1 && b!=y) # edge 1
            # Look at all 3 neighboring squares and find another region to exange tiles with
            temp=k
            if (grid[a+1,b]!=val && k!=temp+1)
                temp=k
                for i in 1:x
                    for j in 1:y  
                        if (i!=a+1 || j!=b)                 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)         
                                        grid[i-1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b-1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y    
                        if (i!=a-1 || j!=b)                  
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)       
                                        grid[i-1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b+1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a || j!=b+1)                   
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)          
                                        grid[i-1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i-1,j]
                                            grid[i-1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
        elseif (a!=1 && a== x && b!= 1 && b!=y) # edge 2
            # Look at all 3 neighboring squares and find another region to exange tiles with
            temp=k
            if (grid[a-1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y
                        if (i!=a-1 || j!=b)                                        
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)  
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i-1,j]
                                            grid[i-1,j]=val                                           
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end
            end
            if (grid[a,b-1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y    
                        if (i!=a-1 || j!=b)                  
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)       
                                        grid[i-1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b+1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a || j!=b+1)                   
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)          
                                        grid[i-1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i-1,j]
                                            grid[i-1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

        elseif (a!=1 && a!= x && b== 1 && b!=y) # edge 3
            temp=k
            # Look at all 3 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y
                        if (i!=a-1 || j!=b)                                        
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)  
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i-1,j]
                                            grid[i-1,j]=val                                           
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end
            end
            if (grid[a+1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a+1 || j!=b)                 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)         
                                        grid[i-1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b+1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a || j!=b+1)                   
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)          
                                        grid[i-1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i-1,j]
                                            grid[i-1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            
            
        elseif (a!=1 && a!= x && b!= 1 && b==y) # edge 4
            temp=k
            # Look at all 3 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y
                        if (i!=a-1 || j!=b)                                        
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)  
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i-1,j]
                                            grid[i-1,j]=val                                           
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end
            end
            if (grid[a+1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a+1 || j!=b)                 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)         
                                        grid[i-1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b-1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y    
                        if (i!=a-1 || j!=b)                  
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)       
                                        grid[i-1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end


        elseif (a==1 && a!= x && b== 1 && b!=y) # corner 1
            temp=k
            # Look at all 2 neighboring squares and find another region to exange tiles with
            if (grid[a+1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a+1 || j!=b)                 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)         
                                        grid[i-1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b+1]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a || j!=b+1)                   
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)          
                                        grid[i-1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i-1,j]
                                            grid[i-1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            
            
        elseif (a==1 && a!= x && b!= 1 && b==y) # corner 2
            temp=k
            # Look at all 2 neighboring squares and find another region to exange tiles with
            if (grid[a+1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y  
                        if (i!=a+1 || j!=b)                 
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a+1,b])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)         
                                        grid[i-1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a+1,b]
                                        grid[a+1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a+1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if (grid[a,b-1]!=val && k!=temp+1)
                temp=k
                for i in 1:x
                    for j in 1:y    
                        if (i!=a-1 || j!=b)                  
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)       
                                        grid[i-1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            

            
        elseif (a!=1 && a== x && b== 1 && b!=y) # corner 3
            temp=k
            # Look at all 2 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y
                        if (i!=a-1 || j!=b)                                        
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)  
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i-1,j]
                                            grid[i-1,j]=val                                           
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end
            end
            if (grid[a,b+1]!=val && k!=temp+1)
                temp=k
                for i in 1:x
                    for j in 1:y  
                        if (i!=a || j!=b+1)                   
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b+1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)          
                                        grid[i-1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i-1,j]
                                            grid[i-1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b+1]
                                        grid[a,b+1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b+1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end


            
        elseif (a!=1 && a== x && b!= 1 && b==y) # corner 4
            temp=k
            # Look at all 2 neighboring squares and find another region to exange tiles with
            if (grid[a-1,b]!=val && k!=temp+1)
                for i in 1:x
                    for j in 1:y
                        if (i!=a-1 || j!=b)                                        
                            # Find another square of new region that is also neighboring the first region                           
                            if (grid[i,j]==grid[a-1,b])
                                if (i!=1 && k!=temp+1)                                
                                    if (grid[i-1,j]==val)  
                                        grid[i-1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i-1,j]
                                            grid[i-1,j]=val                                           
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i+1,j]
                                            grid[i+1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j-1]
                                            grid[i,j-1]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a-1,b]
                                        grid[a-1,b]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a-1,b]=grid[i,j+1]
                                            grid[i,j+1]=val  
                                            k-=1
                                        end
                                    end
                                end   
                            end
                        end
                    end
                end
            end
            if (grid[a,b-1]!=val && k!=temp+1)
                temp=k
                for i in 1:x
                    for j in 1:y    
                        if (i!=a-1 || j!=b)                  
                            # Find another square of new region that is also neighboring the first region
                            if (grid[i,j]==grid[a,b-1])
                                if (i!=1 && k!=temp+1)
                                    if (grid[i-1,j]==val)       
                                        grid[i-1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i-1,j]
                                            grid[i-1,j]=val  
                                            k-=1
                                        end
                                    end
                                end
                                if (i!=x && k!=temp+1)
                                    if (grid[i+1,j]==val)
                                        grid[i+1,j]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i+1,j]
                                            grid[i+1,j]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=1 && k!=temp+1)
                                    if (grid[i,j-1]==val)
                                        grid[i,j-1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j-1]
                                            grid[i,j-1]=val 
                                            k-=1
                                        end
                                    end
                                end
                                if (j!=y && k!=temp+1)
                                    if (grid[i,j+1]==val)
                                        grid[i,j+1]=grid[a,b-1]
                                        grid[a,b-1]=val
                                        k+=1
                                        # Make sure this results in a configuration where the squares of each
                                        # tile are still connected to each other (otherwise undo the modification).
                                        if !isGridValid(grid,sizeR)
                                            grid[a,b-1]=grid[i,j+1]
                                            grid[i,j+1]=val 
                                            k-=1
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

            end

        end        
    end

    #println(grid)

    for i in 1:n
        a=rand(1:x)
        b=rand(1:y)
        s=0
        if (a!=1 && a!= x && b!= 1 && b!=y)
            if grid[a-1,b]!=grid[a,b]
                s+=1
            end
            if grid[a+1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b-1]!=grid[a,b]
                s+=1
            end
            if grid[a,b+1]!=grid[a,b]
                s+=1
            end
        elseif (a==1 && a!= x && b!= 1 && b!=y) # edge 1
            s+=1
            if grid[a+1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b-1]!=grid[a,b]
                s+=1
            end
            if grid[a,b+1]!=grid[a,b]
                s+=1
            end
        elseif (a!=1 && a== x && b!= 1 && b!=y) # edge 2
            s+=1
            if grid[a-1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b-1]!=grid[a,b]
                s+=1
            end
            if grid[a,b+1]!=grid[a,b]
                s+=1
            end
        elseif (a!=1 && a!= x && b== 1 && b!=y) # edge 3
            s+=1
            if grid[a-1,b]!=grid[a,b]
                s+=1
            end
            if grid[a+1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b+1]!=grid[a,b]
                s+=1
            end
        elseif (a!=1 && a!= x && b!= 1 && b==y) # edge 4
            s+=1
            if grid[a-1,b]!=grid[a,b]
                s+=1
            end
            if grid[a+1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b-1]!=grid[a,b]
                s+=1
            end
        elseif (a==1 && a!= x && b== 1 && b!=y) # corner 1
            s+=2
            if grid[a+1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b+1]!=grid[a,b]
                s+=1
            end
        elseif (a==1 && a!= x && b!= 1 && b==y) # corner 2
            s+=2
            if grid[a+1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b-1]!=grid[a,b]
                s+=1
            end
        elseif (a!=1 && a== x && b== 1 && b!=y) # corner 3
            s+=2
            if grid[a-1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b+1]!=grid[a,b]
                s+=1
            end
        elseif (a!=1 && a==x && b!= 1 && b==y) # corner 4
            s+=2
            if grid[a-1,b]!=grid[a,b]
                s+=1
            end
            if grid[a,b-1]!=grid[a,b]
                s+=1
            end            
        end
        if s!=0
            nb[a,b]=s
        end
    end

    #println(nb)
    return nb
end 

"""
Check that each tile is still connected to another of its region

Argument
- x: the grid to check
- sizeR: size of regions
"""

function isGridValid(grid::Matrix{Int64},sizeR::Int64)
    (n,m)=size(grid)
    nbR = round(Int64,(n*m)/sizeR) #number of region
    regionDone = Array{Int64}(zeros(nbR))
    stop = 0
    for i in 1:n
        for j in 1:m
            k = grid[i,j]
            # if the region already have been treated, it is not necessarily
            if regionDone[k]==1
                continue
            end
            visited = Array{Int64}(zeros(n,m))
            visited[i,j] =1
            visited, cpt = recursivePlace(grid,visited,k,i,j,1)
            #if the number of neighbouring cases of region k is not equal to the size of each region : grid not valid
            if cpt!=sizeR
                return false
            end
            regionDone[k] = 1
            stop+=1
            #if we have treated all regions, we don't need to continue the double loop : grid valid
            if stop==nbR
                return true 
            end
        end
    end
    return false
end

function recursivePlace(res::Array{}, visited::Array{}, region::Int64, i::Int64, j::Int64, cpt::Int64)
    n = size(res,1)
    m = size(res,2)
    if i!=n && res[i+1,j]==region && visited[i+1,j]==0
        visited[i+1,j]=1
        cpt+=1
        visited, cpt = recursivePlace(res, visited,region,i+1, j, cpt)
    end
    if j!=m && res[i,j+1]==region && visited[i,j+1]==0
        visited[i,j+1]=1
        cpt+=1
        visited, cpt = recursivePlace(res, visited,region,i, j+1, cpt)
    end
    if i!=1 && res[i-1,j]==region && visited[i-1,j]==0
        visited[i-1,j]=1
        cpt+=1
        visited, cpt = recursivePlace(res, visited,region,i-1, j, cpt)
    end
    if j!=1 && res[i,j-1]==region && visited[i,j-1]==0
        visited[i,j-1]=1
        cpt+=1
        visited, cpt = recursivePlace(res, visited,region,i, j-1, cpt)
    end
    return visited, cpt
end


"""
Generate all the instances

Remark: a grid is generated only if the corresponding output file does not already exist
"""
function generateDataSet()
    # For each grid size considered
    for x in [4,5,6]
        for y in [4,5]
            if y<=x
                # Generate 10 instances
                for instance in 1:10

                    fileName = "../data/instance_x" * string(x) * "_y" * string(y) * "_" * string(instance) * ".txt"

                    if !isfile(fileName)
                        println("-- Generating file " * fileName)
                        saveInstance(generateInstance(x,y,y),y,fileName)
                    end 
                end
            end
        end
    end

    # 6x6
    fileName = "../data/instance_x6_y6.txt"

    if !isfile(fileName)
        println("-- Generating file " * fileName)
        saveInstance(generateInstance(6,6,6),6,fileName)
    end 
    
end



