# This file contains methods to generate a data set of instances (i.e., tents grids)
include("io.jl")

"""
Generate an n*n grid with a given density

Argument
- n: size of the grid
"""
function generateInstance(n::Int64)

    # Nb of trees 
    t=trunc(Int,0.2*n*n)

    # Matrix representing grid, zeros are empty squares, ones are trees, twos are tents
    grid = zeros(Int64, n, n)

    i=0

    while (i<t)
        x = rand(1:n)
        y = rand(1:n)
        #println("x=",x)
        #println("y=",y)
        #println("i=",i)
        
        # s is the number of boxes around the box [x,y] that are empty
        if (x!=1 && x!= n && y!= 1 && y!=n)
            s = ceil(grid[x-1,y]/2)+ceil(grid[x+1,y]/2)+ceil(grid[x,y-1]/2)+ceil(grid[x,y+1]/2)+ceil(grid[x-1,y-1]/2)+ceil(grid[x-1,y+1]/2)+ceil(grid[x+1,y-1]/2)+ceil(grid[x+1,y+1]/2)
        elseif (x==1 && x!= n && y!= 1 && y!=n) # edge 1
            s = ceil(grid[x+1,y]/2)+ceil(grid[x,y-1]/2)+ceil(grid[x,y+1]/2)+ceil(grid[x+1,y-1]/2)+ceil(grid[x+1,y+1]/2)+3
        elseif (x!=1 && x== n && y!= 1 && y!=n) # edge 2
            s = ceil(grid[x-1,y]/2)+ceil(grid[x,y-1]/2)+ceil(grid[x,y+1]/2)+ceil(grid[x-1,y-1]/2)+ceil(grid[x-1,y+1]/2)+3
        elseif (x!=1 && x!= n && y== 1 && y!=n) # edge 3
            s = ceil(grid[x-1,y]/2)+ceil(grid[x+1,y]/2)+ceil(grid[x,y+1]/2)+ceil(grid[x-1,y+1]/2)+ceil(grid[x+1,y+1]/2)+3
        elseif (x!=1 && x!= n && y!= 1 && y==n) # edge 4
            s = ceil(grid[x-1,y]/2)+ceil(grid[x+1,y]/2)+ceil(grid[x,y-1]/2)+ceil(grid[x-1,y-1]/2)+ceil(grid[x+1,y-1]/2)+3
        elseif (x==1 && x!= n && y== 1 && y!=n) # corner 1
            s = ceil(grid[x+1,y]/2)+ceil(grid[x,y+1]/2)+ceil(grid[x+1,y+1]/2)+5
        elseif (x==1 && x!= n && y!= 1 && y==n) # corner 2
            s = ceil(grid[x+1,y]/2)+ceil(grid[x,y-1]/2)+ceil(grid[x+1,y-1]/2)+5
        elseif (x!=1 && x== n && y== 1 && y!=n) # corner 3
            s = ceil(grid[x-1,y]/2)+ceil(grid[x,y+1]/2)+ceil(grid[x-1,y+1]/2)+5
        elseif (x!=1 && x==n && y!= 1 && y==n) # corner 4
            s = ceil(grid[x-1,y]/2)+ceil(grid[x,y-1]/2)+ceil(grid[x-1,y-1]/2)+5
        end

        #println("s=",s)
        #println(grid)

        # Place tree if empty square in coords (x,y) and square is not surrounded by 8 trees or tents
        if (grid[x,y]==0 && s<8)
            grid[x,y]=1
            # Place tent next to tree if empty square and square not next to or diagonal to another tent
            # Boxes if in a corner, on an edge, or not
            if (x!=1 && x!= n && y!= 1 && y!=n)
                temp=grid[x+1,y]+grid[x-1,y]+grid[x,y+1]+grid[x,y-1]
            elseif (x==1 && x!= n && y!= 1 && y!=n) # edge 1
                temp=grid[x+1,y]+grid[x,y+1]+grid[x,y-1]
            elseif (x!=1 && x== n && y!= 1 && y!=n) # edge 2
                temp=grid[x-1,y]+grid[x,y+1]+grid[x,y-1]
            elseif (x!=1 && x!= n && y== 1 && y!=n) # edge 3
                temp=grid[x+1,y]+grid[x-1,y]+grid[x,y+1]
            elseif (x!=1 && x!= n && y!= 1 && y==n) # edge 4
                temp=grid[x+1,y]+grid[x-1,y]+grid[x,y-1]
            elseif (x==1 && x!= n && y== 1 && y!=n) # corner 1
                temp=grid[x+1,y]+grid[x,y+1]
            elseif (x==1 && x!= n && y!= 1 && y==n) # corner 2
                temp=grid[x+1,y]+grid[x,y-1]
            elseif (x!=1 && x== n && y== 1 && y!=n) # corner 3
                temp=grid[x-1,y]+grid[x,y+1]
            elseif (x!=1 && x== n && y!= 1 && y==n) # corner 4
                temp=grid[x-1,y]+grid[x,y-1]
            end

            temp2=temp
            while (temp2!=temp+2)       # While no tent has been placed
                
                # Boxes if in a corner, on an edge, or not
                if (x!=1 && x!= n && y!= 1 && y!=n)
                    if (x!=2 && x!= n-1 && y!= 2 && y!=n-1)                        
                        if (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        else
                            temp2=temp2
                        end   

                    elseif (x==2 && x!= n-1 && y!= 2 && y!=n-1) #inside, line 2                        
                        if (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                        
                    elseif (x!=2 && x== n-1 && y!= 2 && y!=n-1) #inside, line n-1                        
                        if (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (x!=2 && x!= n-1 && y== 2 && y!=n-1) #inside, column 2                         
                        if (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                       
                    elseif (x!=2 && x!= n-1 && y!= 2 && y==n-1) #inside, column n-1                        
                        if (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-2,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                        
                    elseif (x==2 && x!= n-1 && y==2 && y!=n-1) #inside, line and column 2                        
                        if (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                        
                    elseif (x!=2 && x== n-1 && y!= 2 && y==n-1) #inside, line and column n-1
                        if (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-2,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                       
                    elseif (x==2 && x!= n-1 && y!= 2 && y==n-1) #inside, line 2 and column n-1
                        if (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                        
                    elseif (x!=2 && x== n-1 && y== 2 && y!=n-1) #inside, line n-1 and column 2
                        if (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                    end


                elseif (x==1 && x!= n && y!= 1 && y!=n) # edge 1      
                    if (y!=2 && y!=n-1)             
                        if (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (y==2)
                        if (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (y==n-1)
                        if (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x+1,y+1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                    end
    
                elseif (x!=1 && x== n && y!= 1 && y!=n) # edge 2
                    if (y!=2 && y!=n-1)
                        if (grid[x,y+1]==0 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (y==2)
                        if (grid[x,y+1]==0 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (y==n-1)
                        if (grid[x,y+1]==0 && grid[x-1,y+1]!=2 && grid[x-2,y]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                    end

                elseif (x!=1 && x!= n && y==1 && y!=n) # edge 3
                    if (x!=2 && x!=n-1)
                        if (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x+1,y+1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-1,y+1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (x==2)
                        if (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x+1,y+1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x-1,y+1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (x==n-1)
                        if (grid[x+1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x+1,y+1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-1,y+1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                            temp2+=2
                            grid[x,y+1]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                    end
                   
                elseif (x!=1 && x!= n && y!= 1 && y==n) # edge 4
                    if (x!=2 && x!=n-1)
                        if (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y-1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (x==2)
                        if (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y-1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y-1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end

                    elseif (x==n-1)
                        if (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y-1]!=2)
                            temp2+=2
                            grid[x-1,y]=2
                            i+=1
                        elseif (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                            temp2+=2
                            grid[x,y-1]=2
                            i+=1
                        elseif (grid[x+1,y]==0 && grid[x,y]!=2 && grid[x,y-1]!=2 && grid[x+1,y-1]!=2)
                            temp2+=2
                            grid[x+1,y]=2
                            i+=1
                        else
                            temp2=temp2
                        end
                    end

                elseif (x==1 && x!= n && y==1 && y!=n) # corner 1
                    if (grid[x,y+1]==0 && grid[x+1,y+1]!=2 && grid[x+1,y+2]!=2 && grid[x+1,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                        temp2+=2
                        grid[x,y+1]=2
                        i+=1
                    elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y+1]!=2 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x+1,y+1]!=2)
                        temp2+=2
                        grid[x+1,y]=2
                        i+=1
                    else
                        temp2=temp2
                    end
                    
                elseif (x==1 && x!= n && y!= 1 && y==n) # corner 2
                    if (grid[x,y-1]==0 && grid[x+1,y-1]!=2 && grid[x+1,y]!=2 && grid[x,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                        temp2+=2
                        grid[x,y-1]=2
                        i+=1
                    elseif (grid[x+1,y]==0 && grid[x+2,y]!=2 && grid[x+2,y-1]!=2 && grid[x,y]!=2 && grid[x,y-1]!=2 && grid[x+1,y-1]!=2)
                        temp2+=2
                        grid[x+1,y]=2
                        i+=1
                    else
                        temp2=temp2
                    end
                    
                elseif (x!=1 && x== n && y==1 && y!=n) # corner 3
                    if (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y+1]!=2 && grid[x-2,y]!=2 && grid[x-2,y+1]!=2 && grid[x-1,y+1]!=2)
                        temp2+=2
                        grid[x-1,y]=2
                        i+=1
                    elseif (grid[x,y+1]==0 && grid[x-1,y+1]!=2 && grid[x-1,y+2]!=2 && grid[x-2,y]!=2 && grid[x,y+2]!=2 && grid[x,y]!=2)
                        temp2+=2
                        grid[x,y+1]=2
                        i+=1
                    else
                        temp2=temp2
                    end

                elseif (x!=1 && x== n && y!= 1 && y==n) # corner 4                  
                    if (grid[x,y-1]==0 && grid[x,y-2]!=2 && grid[x-1,y-1]!=2 && grid[x-1,y]!=2 && grid[x-1,y-2]!=2 && grid[x,y]!=2 && grid[x,y-2]!=2)
                        temp2+=2
                        grid[x,y-1]=2
                        i+=1
                    elseif (grid[x-1,y]==0 && grid[x,y]!=2 && grid[x,y-1]!=2 && grid[x-2,y]!=2 && grid[x-2,y-1]!=2 && grid[x-1,y-1]!=2)
                        temp2+=2
                        grid[x-1,y]=2
                        i+=1
                    else
                        temp2=temp2
                    end
                else
                    temp2=temp2
                end
                if (temp2==temp)
                    grid[x,y]=0
                    temp2+=2
                end
            end
            #println(grid)       
        end
    end

    sumx=zeros(Int64, n, 1)
    sumy=zeros(Int64, 1, n)
    res=zeros(Int64, n+1, n+1)
    for i in 1:n
        for j in 1:n
            if grid[i,j]==1
                res[i,j]=1
            elseif grid[i,j]==2
                sumx[i,1]+=1
                sumy[1,j]+=1
            end
        end
    end
    for k in 1:n
        res[k,n+1]=sumx[k,1]
        res[n+1,k]=sumy[1,k]
    end
    #println(res)

    return res
end 


"""
Generate all the instances

Remark: a grid is generated only if the corresponding output file does not already exist
"""
function generateDataSet()

    # For each grid size considered
    for size in [8, 10, 15]

        # Generate 10 instances
        for instance in 1:10

            fileName = "../data/instance_t" * string(size) * "_" * string(instance) * ".txt"

            if !isfile(fileName)
                println("-- Generating file " * fileName)
                saveInstance(generateInstance(size), fileName)
            end 
        end
    
    end
    
end



    