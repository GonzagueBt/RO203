# This file contains methods to generate a data set of instances (i.e., tents grids)
include("io.jl")

"""
Generate an n*n grid with a given density

Argument
- n: size of the grid
"""
function generateInstance(n::Int64)

    # Nb of trees 
    if n<10
        t=trunc(int,0.18*n*n)
    else
        t=trunc(int,0.2*n*n)
    end

    # Matrix representing grid, zeros are empty squares, ones are trees, twos are tents
    grid = zeros(Int64, n, n)

    i=0

    while (i<t)
        x = rand(r[1:n])
        y = rand(r[1:n])
        s = grid[x-1][y]+grid[x+1][y]+grid[x][y-1]+grid[x][y+1]+grid[x-1][y-1]+grid[x-1][y+1]+grid[x+1][y-1]+grid[x+1][y+1]
        # Place tree if empty square in coords (x,y) and square is not surrounded by 8 trees
        if (grid[x][y]==0 && s<8)
            grid[x][y]=1
            # Place tent next to tree if empty square and square not next to or diagonal to another tent
            # Cases if in a corner, on an edge, or not
            if (x!=1 && x!= n && y!= 1 && y!=n)
                temp=grid[x+1][y]+grid[x-1][y]+grid[x][y+1]+grid[x][y-1]
            elseif (x==1 && x!= n && y!= 1 && y!=n) # edge 1
                temp=grid[x+1][y]+grid[x][y+1]+grid[x][y-1]
            elseif (x!=1 && x== n && y!= 1 && y!=n) # edge 2
                temp=grid[x-1][y]+grid[x][y+1]+grid[x][y-1]
            elseif (x!=1 && x!= n && y== 1 && y!=n) # edge 3
                temp=grid[x+1][y]+grid[x-1][y]+grid[x][y+1]
            elseif (x!=1 && x!= n && y!= 1 && y==n) # edge 4
                temp=grid[x+1][y]+grid[x-1][y]+grid[x][y-1]
            elseif (x==1 && x!= n && y== 1 && y!=n) # corner 1
                temp=grid[x+1][y]+grid[x][y+1]
            elseif (x==1 && x!= n && y!= 1 && y==n) # corner 2
                temp=grid[x+1][y]+grid[x][y-1]
            elseif (x!=1 && x== n && y== 1 && y!=n) # corner 3
                temp=grid[x-1][y]+grid[x][y+1]
            elseif (x!=1 && x== n && y!= 1 && y==n) # corner 4
                temp=grid[x-1][y]+grid[x][y-1]
            end
            
            temp2=temp
            while (temp!=temp2+2)       # While no tent has been placed
                alea = rand(r[1:4])
                # Cases if in a corner, on an edge, or not
                if (x!=1 && x!= n && y!= 1 && y!=n)
                    if (alea==1)
                        if (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x+1][y+1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x+1][y+1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x+1][y+1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x+1][y+1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    end
                elseif(x==1 && x!= n && y!= 1 && y!=n) # edge 1
                    if (alea==1)
                        if (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x+1][y+1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x+1][y+1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x+1][y+1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x+1][y+1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    end
                elseif(x!=1 && x== n && y!= 1 && y!=n) # edge 2
                    if (alea==1)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x][y-1]==0 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y+1]==0 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        end
                    end
                elseif(x!=1 && x!= n && y== 1 && y!=n) # edge 3
                    if (alea==1)
                        if (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x+1][y+1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-1][y+1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x+1][y+1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-1][y+1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x+1][y+1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-1][y+1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-1][y+1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x+1][y+1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    end
                elseif(x!=1 && x!= n && y!= 1 && y==n) # edge 4
                    if (alea==1)
                        if (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    end
                elseif(x==1 && x!= n && y==1 && y!=n) # corner 1
                    if (alea==1)
                        if (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x+1][y+1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x+1][y+1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x+1][y+1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x][y+1]==0 && grid[x+1][y+1]!=2 && grid[x+1][y+2]!=2 && grid[x+1][y]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y+1]!=2 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x+1][y+1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    end
                elseif(x==1 && x!= n && y!= 1 && y==n) # corner 2
                    if (alea==1)
                        if (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x][y-1]==0 && grid[x+1][y-1]!=2 && grid[x+1][y]!=2 && grid[x][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x+1][y]==0 && grid[x+2][y]!=2 && grid[x+2][y-1]!=2 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x+1][y-1]!=2)
                            temp2+=2
                            grid[x+1][y]=2
                            i+=1
                        end
                    end
                elseif(x!=1 && x== n && y==1 && y!=n) # corner 3
                    if (alea==1)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-1][y+1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-1][y+1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y+1]==0 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-1][y+1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y+1]!=2 && grid[x-2][y]!=2 && grid[x-2][y+1]!=2 && grid[x-1][y+1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y+1]==0 && grid[x-1][y+1]!=2 && grid[x-1][y+2]!=2 && grid[x-2][y]!=2 && grid[x][y+2]!=2 && grid[x][y]!=2)
                            temp2+=2
                            grid[x][y+1]=2
                            i+=1
                        end
                    end
                elseif(x!=1 && x== n && y!= 1 && y==n) # corner 4
                    if (alea==1)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        end
                    elseif (alea==2)
                        if (grid[x][y-1]==0 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        end
                    elseif (alea==3)
                        if (grid[x][y-1]==0 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        elseif (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        end
                    elseif (alea==4)
                        if (grid[x-1][y]==0 && grid[x][y]!=2 && grid[x][y-1]!=2 && grid[x-2][y]!=2 && grid[x-2][y-1]!=2 && grid[x-1][y-1]!=2)
                            temp2+=2
                            grid[x-1][y]=2
                            i+=1
                        elseif (grid[x][y-1]==0 && grid[x][y-2]!=2 && grid[x-1][y-1]!=2 && grid[x-1][y]!=2 && grid[x-1][y-2]!=2 && grid[x][y]!=2 && grid[x][y-2]!=2)
                            temp2+=2
                            grid[x][y-1]=2
                            i+=1
                        end
                    end
                end
            end
            if (temp2==temp)
                grid[x][y]=0
            end        
        end
    end
    


    println("In file generation.jl, in method generateInstance(), TODO: generate an instance")
    
end 

function isGridValid()


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



