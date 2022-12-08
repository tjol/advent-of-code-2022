module Day08
    export day08part1, day08part2

    function day08part1(s)
        map = parsetrees(s)
        vismap = getvismap(map)
        count(vismap)
    end

    function day08part2(s)
        map = parsetrees(s)
        h, w = size(map)
        scores = zeros(Int, h, w)
        for i in 1:h
            for j in 1:w
                scores[i, j] = scenicscore(map, i, j)
            end
        end
        maximum(scores)
    end

    function parsetrees(s)
        lines = split(strip(s), '\n')
        h = length(lines)
        w = length(lines[1])
        map = zeros(UInt8, h, w)
        for i in 1:h
            for j in 1:w
                map[i,j] = parse(UInt8, lines[i][j])
            end
        end
        map
    end

    function getvismap(map)
        h, w = size(map)
        visible = zeros(Bool, h, w)
        visible[1, :] .= true
        visible[end, :] .= true
        visible[:, 1] .= true
        visible[:, end] .= true

        # Check from the left
        for i in 2:h-1
            tree = map[i, 1]
            for j in 2:w-1
                if map[i, j] > tree
                    tree = map[i, j]
                    visible[i, j] = true
                end
            end
        end

        # Check from the right
        for i in 2:h-1
            tree = map[i, end]
            for j in w-1:-1:2
                if map[i, j] > tree
                    tree = map[i, j]
                    visible[i, j] = true
                end
            end
        end

        # Check from the top
        for j in 2:w-1
            tree = map[1, j]
            for i in 2:h-1
                if map[i, j] > tree
                    tree = map[i, j]
                    visible[i, j] = true
                end
            end
        end

        # Check from the bottom
        for j in 2:w-1
            tree = map[end, j]
            for i in h-1:-1:2
                if map[i, j] > tree
                    tree = map[i, j]
                    visible[i, j] = true
                end
            end
        end
        
        visible
    end

    function scenicscore(map, i, j)
        h, w = size(map)
        tree = map[i, j]
        
        # Look left
        l = 0
        for jj in j-1:-1:1
            l += 1
            if map[i, jj] >= tree
                break
            end
            curheight = map[i, jj]
        end

        # Look right
        r = 0
        for jj in j+1:w
            r += 1
            if map[i, jj] >= tree
                break
            end
            curheight = map[i, jj]
        end

        # Look up
        u = 0
        for ii in i-1:-1:1
            u += 1
            if map[ii, j] >= tree
                break
            end
            curheight = map[ii, j]
        end

        # Look down
        d = 0
        for ii in i+1:h
            d += 1
            if map[ii, j] >= tree
                break
            end
            curheight = map[ii, j]
        end

        l * r * u * d
    end
end

using .Day08
