module Day12
    export day12part1, day12part2

    using DataStructures: BinaryMinHeap

    struct Map
        startpoint::Vector{Int64}
        endpoint::Vector{Int64}
        map::Matrix{Int8}
    end

    function day12part1(s)
        m = parse(Map, s)
        shortestpath(m)
    end

    function day12part2(s)
        m = parse(Map, s)
        maps = permutemap(m)
        dists = filter(x -> x !== nothing, map(shortestpath, maps))
        minimum(dists)
    end

    function parse(Map, s)
        lines = split(strip(s), '\n')
        w = length(lines[1])
        h = length(lines)
        map = zeros(Int8, w, h)
        startpoint = nothing
        endpoint = nothing
        for (y, line) in enumerate(lines)
            for (x, c) in enumerate(line)
                if c == 'S'
                    map[x, y] = 0
                    startpoint = [x, y]
                elseif c == 'E'
                    map[x, y] = 25
                    endpoint = [x, y]
                else
                    map[x, y] = c - 'a'
                end
            end
        end
        Map(startpoint, endpoint, map)
    end

    function shortestpath(mapinfo::Map)
        hmap = mapinfo.map
        w, h = size(hmap)
        stepmap = fill(w * h + 1, (w, h)) # Practically infinity
        stepmap[mapinfo.startpoint...] = 0
        visited = zeros(Bool, (w, h))
        distmap = zeros((w, h))
        for x in 1:w
            for y in 1:h
                distmap[x, y] = abs(x - mapinfo.endpoint[1]) + abs(y - mapinfo.endpoint[2])
            end
        end

        # (prio, x, y) heap
        q = BinaryMinHeap{Tuple{Int64, Int64, Int64}}()
        push!(q, (0, mapinfo.startpoint...))

        # A* search
        while !isempty(q)
            _, x, y = pop!(q)
            steps = stepmap[x, y]
            if visited[x, y]
                continue
            elseif [x, y] == mapinfo.endpoint
                return steps
            end
            visited[x, y] = true
            maxheight = hmap[x, y] + 1
            # Check all neighbours
            for (x2, y2) in [(x, y-1), (x, y+1), (x-1, y), (x+1, y)]
                if x2 <= 0 || y2 <= 0 || x2 > w || y2 > h  || hmap[x2, y2] > maxheight
                    # out of bounds or too high up
                    continue
                end
                # Check if this is the new shortest path
                if stepmap[x2, y2] > steps + 1
                    # We found a faster way to get there!
                    stepmap[x2, y2] = steps + 1
                    prio2 = steps + 1 + distmap[x2, y2]
                    # Insert into queue
                    push!(q, (prio2, x2, y2))
                end
            end
        end
    end

    function permutemap(mapinfo::Map)
        # Find all valid start points
        startpoints::Vector{Vector{Int64}} = []
        hmap = mapinfo.map
        w, h = size(hmap)
        for x in 1:w
            for y in 1:h
                if hmap[x, y] == 0
                    push!(startpoints, [x, y])
                end
            end
        end

        map(startpoint -> Map(startpoint, mapinfo.endpoint, hmap), startpoints)
    end
end

using .Day12
