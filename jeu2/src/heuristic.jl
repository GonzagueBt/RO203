
""" Initialisation palisade """
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

function findEmptyRegion(rsize::Array{})
    for i in 1:size(rsize,1)
        if rsize[i]==0
            return i
        end
    end
    return 0
end


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

function down(res::Array{}, memory::Array{}, palisade::Array{},i::Int64, j::Int64, k::Int64)
    if res[i+1,j]==k && res[i+1,j]!=memory[i+1,j]
        palisade[i,j]-=1
    end
    return palisade
end

function up(res::Array{}, memory::Array{}, palisade::Array{},i::Int64, j::Int64, k::Int64)
    if res[i-1,j]==k && res[i-1,j]!=memory[i-1,j]
        palisade[i,j]-=1
    end
    return palisade
end

function right(res::Array{}, memory::Array{}, palisade::Array{},i::Int64, j::Int64, k::Int64)
    if res[i,j+1]==k && res[i,j+1]!=memory[i,j+1]
        palisade[i,j]-=1
    end
    return palisade
end

function left(res::Array{}, memory::Array{}, palisade::Array{},i::Int64, j::Int64, k::Int64)
    if res[i,j-1]==k && res[i,j-1]!=memory[i,j-1]
        palisade[i,j]-=1
    end
    return palisade
end

function isFreeSpace(res::Array{}, rsize::Array{}, sizeR::Int64)
    reg = findEmptyRegion(rsize)
    if reg==0
        return res, rsize
    end
    n = size(res,1)
    m = size(res,2)
    for i in 1:n
        for j in 1:m
            #if i*j> n*m-sizeR
            #    break
            #end
            if res[i,j]!=0
                continue
            end
            visited = Array{Int64}(zeros(n,m))
            visited[i,j] =1
            visited, cpt = recursivePlace(res,visited,i, j,1)
            if cpt!=sizeR
                continue
            end
            for a in 1:n
                for b in 1:n
                    if visited[a,b]==1
                        res[a,b] = reg
                    end
                end
            end
            rsize[reg] = sizeR
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
                if i==2 && j==2 
                    println("a=",a," et b=",b)
                    println("je suis bien ici")
                    println(palisade[3,2])
                    println(cpt)
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