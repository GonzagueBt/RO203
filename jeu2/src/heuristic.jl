
"""
Check if the solution of the instance is completed
"""
function instanceIsComplete(rsize::Array, sizeR::Int64)
    for i in 1:size(rsize,1)
        if rsize[i]!= sizeR
            return false
        end
    end
    return true
end

""" Initialisation palisade
Create and initialize an array Palisade, which, for each case, indcates the number of palisade who can
currently be set.
if the value of the case i is equal to 0, that leans that all the neighbors of the case i are in the same
region that i
"""
function initPalisade(t::Array{})
    n = size(t,1)
    m = size(t,2)
    palisade = Array{Int64}(zeros(n,m))
    for i in 2:n-1
        for j in 2:m-1
            if t[i,j]!= 0
                palisade[i,j] = t[i,j]
            else
                palisade[i,j] = 3
            end
        end
    end
    for j in 2:m-1
        if t[1,j]!=0
            palisade[1,j] = t[1,j] - 1
        else
            palisade[1,j] = 2
        end
        if t[n,j]!=0
            palisade[n,j] = t[n,j] - 1
        else
            palisade[n,j] = 2
        end
    end
    for i in 2:n-1
        if t[i,1]!=0
            palisade[i,1] = t[i,1] - 1
        else
            palisade[i,1] = 2
        end
        if t[i,m]!=0
            palisade[i,m] = t[i,m] - 1
        else
            palisade[i,m] = 2
        end
    end
    if t[1,1]!=0
        palisade[1,1] = t[1,1] - 2
    else
        palisade[1,1] = 1
    end
    if t[1,m]!=0
        palisade[1,m] = t[1,m] - 2
    else
        palisade[1,m] = 1
    end
    if t[n,1]!=0
        palisade[n,1] = t[n,1] - 2
    else
        palisade[n,1] = 1
    end
    if t[n,m]!=0
        palisade[n,m] = t[n,m] - 2
    else
        palisade[n,m] = 1
    end
    return palisade
end

"""
Take in argument a case (i,j), and look if it can be add to a region.
To check that, the function check it neighbors (with addi, addj, addij, addji) :  they need to not be in an not full region
"""
function findRegion(rsize::Array{}, sizeR::Int64, res::Array{}, i::Int64, j::Int64, addi::Int64, addj::Int64, addij::Int64, addji::Int64)
    nbcase = 1
    n = size(res,1)
    m = size(res,2)
    if res[i+addi, j]==0 
        nbcase +=1
    end
    if res[i, j+addj]==0 
        nbcase+=1
    end
    if addij!=0 && res[i+addij, j]==0
        nbcase+=1
    end
    if addji!=0 && res[i, j+addji]==0
        nbcase +=1
    end
    cpt=0
    fill = true
    isRegionOk = Array{Int64}(ones(round(Int64,(n*m)/sizeR)))
    for k in 1:size(rsize,1)
        if rsize[k]==0
            cpt+=1
        elseif rsize[k]!=sizeR
            fill = false
            if rsize[k]+nbcase <= sizeR
                isRegionOk[k]=0
            end
        end 
    end
    ### if all region are enpty for now ###
    if cpt==round(Int64,(n*m)/sizeR)
        return 1
    end
    ### if all region with cases are full ###
    for k in 1:size(rsize,1)
        if rsize[k]==0
            return k
        end
    end

    for a in 1:size(res,1)
        for b in 1:size(res,2)
            if res[a,b]!=0 && (abs(i-a)+abs(j-b))>=sizeR
                isRegionOk[res[a,b]]=1
            end
        end
    end
    for a in 1:size(isRegionOk,1)
        if isRegionOk[a]==0
            return a
        end
    end
    return -1
end

"""
Return a region which is yet empty
"""
function findEmptyRegion(rsize::Array{})
    for i in 1:size(rsize,1)
        if rsize[i]==0
            return i
        end
    end
    return 0
end

"""
Check all cases, if the case i is not yet in a region and can have 0 palisade, then we find a region k with findRegion, 
and we add i and his neighbors to the region k (besause it can't have palisade between them, so there are in the same)
"""
function firstFilling(rsize::Array{}, palisade::Array{}, res::Array{}, sizeR::Int64)
    n = size(res,1)
    m = size(res,2)
    for i in 1:n
        for j in 1:m
            if res[i,j]!=0 || palisade[i,j]!=0
                continue
            end
            reg=-1
            addi = 1
            addj = 1
            addij = 0
            addji = 0
            if i==1
                if j==1
                    reg = findRegion(rsize,sizeR, res, i, j, addi, addj,addij, addji)
                elseif j==m
                    addj = -1
                    reg = findRegion(rsize,sizeR, res, i, j, addi, addj, addij, addji) 
                else
                    addji = -1
                    reg = findRegion(rsize,sizeR, res, i, j, addi, addj, addij, addji)
                end
            elseif i==n
                addi = -1
                if j==1
                    reg = findRegion(rsize,sizeR, res, i, j, addi, addj, addij, addji)
                elseif j==m
                    addj = -1
                    reg = findRegion(rsize,sizeR, res, i, j, addi, addj, addij, addji) 
                else
                    addji = -1
                    reg = findRegion(rsize,sizeR, res, i, j, addi, addj, addij, addji)
                end
            elseif j==1 && i!=1 && i!=n
                addij = -1
                reg = findRegion(rsize,sizeR, res, i, j, addi, addj, addij, addji)
            elseif j==m && i!=1 && i!=n
                addj = -1
                addij= -1
                reg = findRegion(rsize,sizeR, res, i, j, addi, addj, addij, addji)
            else
                addij = -1
                addji = -1
                reg = findRegion(rsize,sizeR, res, i, j, addi, addj, addij, addji)
            end
            if reg!=-1
                nbcase = 1
                res[i,j]=reg
                if res[i+addi, j] == 0
                    res[i+addi, j] = reg
                    nbcase+=1
                end
                if res[i+addi, j] == 0
                    res[i+addi, j] = reg
                    nbcase+=1
                end
                if res[i, j+addj] == 0
                    res[i, j+addj] = reg
                    nbcase+=1
                end
                if res[i+addij, j] ==0
                    res[i+addij, j] = reg
                    nbcase+=1
                end
                if res[i, j+addji] == 0
                    res[i, j+addji] = reg
                    nbcase+=1
                end
                rsize[reg] += nbcase
            end
        end
    end
    return res, rsize
end


"""
This function is nearly like firstFillinf, but try to add neighbors of a case i which is already in a region and can't have
other palisade (automatically, the region is not full)
"""
function secondFilling(rsize::Array{}, palisade::Array{}, res::Array{}, sizeR::Int64)
    n = size(res,1)
    m = size(res,2)
    for i in 1:n
        for j in 1:m
            if res[i,j]==0 || palisade[i,j]!=0 || rsize[res[i,j]]==sizeR
                continue
            end
            reg=res[i,j]
            addi = 1
            addj = 1
            addij = 0
            addji = 0
            if i==1
                if j==m
                    addj = -1
                elseif j!=1 && j!=m
                    addji = -1
                end
            elseif i==n
                addi = -1
                if j==m
                    addj = -1
                elseif j!=1 && j!=m
                    addji = -1
                end
            elseif j==1 && i!=1 && i!=n
                addij = -1
            elseif j==m && i!=1 && i!=n
                addj = -1
            elseif j!=1 && j!=m
                addij = -1
                addji = -1
            end

            nbcase = 0
            if res[i+addi, j] == 0
                res[i+addi, j] = reg
                nbcase+=1
            end
            if res[i+addi, j] == 0
                res[i+addi, j] = reg
                nbcase+=1
            end
            if res[i, j+addj] == 0
                res[i, j+addj] = reg
                nbcase+=1
            end
            if res[i+addij, j] ==0
                res[i+addij, j] = reg
                nbcase+=1
            end
            if res[i, j+addji] == 0
                res[i, j+addji] = reg
                nbcase+=1
            end
            rsize[reg] += nbcase
        end
    end
    return res, rsize
end

"""
if a region k is full, all cases of k with a neighbors in the region k can have one less possible palisade.
Careful : this function is used only when the grid have been modify, otherwise, tis action will be done several times
"""
function updatePalisade(rsize::Array{}, palisade::Array{}, res::Array{}, memory::Array{}, sizeR::Int64)
    n = size(res,1)
    m = size(res,2)
    for k in 1:size(rsize,1)
        if rsize[k]==sizeR
            for i in 1:n
                for j in 1:m
                    if i!=1
                        palisade = up(res, memory,palisade,i, j,k)
                    end
                    if j!=1
                        palisade = left(res,memory, palisade,i, j,k)
                    end
                    if j!=m
                        palisade = right(res, memory,palisade,i, j,k)
                    end
                    if i!=n
                        palisade = down(res, memory,palisade,i, j,k)
                    end
                end
            end
        end
    end
    return palisade
end

""" 
we check if the down neighbor of a case have changed since last time, 
"""
function down(res::Array{}, memory::Array{}, palisade::Array{},i::Int64, j::Int64, k::Int64)
    if res[i+1,j]==k && res[i+1,j]!=memory[i+1,j]
        palisade[i,j]-=1
    end
    return palisade
end
""" idem but up"""
function up(res::Array{}, memory::Array{}, palisade::Array{},i::Int64, j::Int64, k::Int64)
    if res[i-1,j]==k && res[i-1,j]!=memory[i-1,j]
        palisade[i,j]-=1
    end
    return palisade
end
""" idem but right"""
function right(res::Array{}, memory::Array{}, palisade::Array{},i::Int64, j::Int64, k::Int64)
    if res[i,j+1]==k && res[i,j+1]!=memory[i,j+1]
        palisade[i,j]-=1
    end
    return palisade
end
""" idem but left"""
function left(res::Array{}, memory::Array{}, palisade::Array{},i::Int64, j::Int64, k::Int64)
    if res[i,j-1]==k && res[i,j-1]!=memory[i,j-1]
        palisade[i,j]-=1
    end
    return palisade
end


"""
This function calls the recursive function recursivePlace. It traverses the grid, if it finds a square not yet assigned 
to a region, it will jump from neighbor to neighbor until it is blocked in all directions, 
to count the number of "empty" squares side by side. If this number of squares is equal to the size of a region, 
and a region has no squares yet, then we can add all the squares to this empty region
"""
function isFreeSpace(res::Array{}, rsize::Array{}, sizeR::Int64)
    reg = findEmptyRegion(rsize)
    if reg==0
        return res, rsize
    end
    n = size(res,1)
    m = size(res,2)
    done = false
    k,l = 0,0
    for i in 1:n
        for j in 1:m
            if res[i,j]!=0
                continue
            end
            visited = Array{Int64}(zeros(n,m))
            visited[i,j] =1
            visited, cpt = recursivePlace(res,visited,i, j,1)
            if cpt!=sizeR
                if cpt>= sizeR && checkEligibilityNewRegion(res, rsize, sizeR, i,j)
                    k,l = i,j
                end
                continue
            end
            done = true
            for a in 1:n
                for b in 1:m
                    if visited[a,b]==1
                        res[a,b] = reg
                    end
                end
            end
            rsize[reg] = sizeR
        end
    end
    if !done && k!=0
        region = findEmptyRegion(rsize)
        if region!=0
            res[k,l] = region
            rsize[region] +=1
        end
    end
    return res, rsize             
end

function recursivePlace(res::Array{}, visited::Array{},i::Int64, j::Int64, cpt::Int64)
    n = size(res,1)
    m = size(res,2)
    if i!=n && res[i+1,j]==0 && visited[i+1,j]==0
        visited[i+1,j]=1
        cpt+=1
        visited, cpt = recursivePlace(res, visited,i+1, j, cpt)
    end
    if j!=m && res[i,j+1]==0 && visited[i,j+1]==0
        visited[i,j+1]=1
        cpt+=1
        visited, cpt = recursivePlace(res, visited,i, j+1, cpt)
    end
    if i!=1 && res[i-1,j]==0 && visited[i-1,j]==0
        visited[i-1,j]=1
        cpt+=1
        visited, cpt = recursivePlace(res, visited,i-1, j, cpt)
    end
    if j!=1 && res[i,j-1]==0 && visited[i,j-1]==0
        visited[i,j-1]=1
        cpt+=1
        visited, cpt = recursivePlace(res, visited,i, j-1, cpt)
    end
    return visited, cpt
end

"""
if a case i have more neighbors from a same region k than it number of palisade remaining authorized, then the case i 
must belong to region k
"""
function notEnoughPalisade(res::Array{}, palisade::Array{}, rsize::Array{}, sizeR::Int64)
    n = size(res,1)
    m = size(res,2)
    for i in 1:n
        for j in 1:m
            if res[i,j]!=0
                continue
            end
            memory = Array{Int64}(zeros(round(Int64,(n*m)/sizeR)))
            if i!=1 && res[i-1,j]!=0
                memory[res[i-1,j]] +=1
            end
            if i!=n && res[i+1,j]!=0
                memory[res[i+1,j]] +=1
            end
            if j!=1 && res[i,j-1]!=0
                memory[res[i,j-1]] +=1
            end
            if j!=m && res[i,j+1]!=0
                memory[res[i,j+1]] +=1
            end

            for k in 1:size(rsize,1)
                if memory[k]> palisade[i,j] && rsize[k]<sizeR
                    res[i,j] = k
                    rsize[k] +=1
                    break
                end
            end
        end
    end
    return res, rsize
end




"""
if there is only one region not full, we had all the remaining cases in this region
"""
function only1notEmpty(res::Array{}, rsize::Array{}, sizeR::Int64)
    n = size(res,1)
    m = size(res,2)
    cpt=0
    reg = 0
    for k in 1:size(rsize,1)
        if rsize[k]!= sizeR
            cpt+=1
            reg=k
        end
    end
    if cpt!=1
        return res, rsize
    end 
    for i in 1:n
        for j in 1:m
            if res[i,j]==0
                res[i,j]=reg
                rsize[reg]+=1
            end
        end
    end
    return res, rsize
end

"""
used in isFreeSpace
"""
function checkEligibilityNewRegion(res::Array{}, rsize::Array{}, sizeR::Int64, i::Int64, j::Int64)
    n = size(res,1)
    m = size(res,2)
    for a in 1:sizeR-1
        # if case (i-1,j) exist and don't have a not full region too close of it (distance less than sizeR)
        if i-a>0 && res[i-a,j]!=0 && rsize[res[i-a,j]]!=sizeR
            return false
        end
        if i+a<=n && res[i+a,j]!=0 && rsize[res[i+a,j]]!=sizeR
            return false
        end
        if j-a>0 && res[i,j-a]!=0 && rsize[res[i,j-a]]!=sizeR
            return false
        end
        if j+a<=m && res[i,j+a]!=0 && rsize[res[i,j+a]]!=sizeR
            return false
        end
    end
    return true
end

"""
if a case i of region k has a neighbor for which the number of it initial authorized palissade is equal to the number of
    neighbor that are not in region k (but are in a region), then this case is added to region k
"""
function oneMoreCase(t::Array{},res::Array{}, palisade::Array{}, rsize::Array{}, sizeR::Int64)
    n = size(res,1)
    m = size(res,2)
    for k in 1:size(rsize,1)
        if rsize[k]!= sizeR-1 
            continue
        end
        for i in 1:n
            for j in 1:m
                a = i
                b = j
                cpt=4
                if res[i,j]!=k
                    continue
                end
                if i!=1 && res[i-1,j]==0
                    a -= 1 
                    cpt = howmanyNeighbor(res, i-1, j, k, 2)
                elseif i!=n && res[i+1,j]==0
                    a+=1
                    cpt = howmanyNeighbor(res, i+1, j, k, 1)
                elseif j!=1 && res[i,j-1]==0
                    b-=1
                    cpt = howmanyNeighbor(res, i, j-1, k, 4)
                elseif j!=m && res[i,j+1]==0
                    b+=1
                    cpt = howmanyNeighbor(res, i, j+1, k, 3)
                end
                cpt2 = howmanyNeighbor(res, i, j, k, 0) 
                if cpt==initPalisade(t)[a,b] && cpt2!=initPalisade(t)[i,j]
                    res[a,b]=k
                    rsize[k] +=1
                    return res, rsize
                end
            end
        end
    end
    return res, rsize
end

"""
Count the number of neighbor of the case (i,j) in the region 'region'
"""
function howmanyNeighbor(res::Array{}, i::Int64, j::Int64, region::Int64, num::Int64)
    n = size(res,1)
    m = size(res,2)
    cpt=0
    if num!=1 && i!=1 && res[i-1,j]!=region
        cpt+=1
    end
    if num!=2 && i!=n && res[i+1,j]!=region
        cpt+=1
    end
    if num!=3 && j!=1 && res[i,j-1]!=region
        cpt+=1
    end
    if num!=4 && j!=m && res[i,j+1]!=region
        cpt+=1
    end
    return cpt
end