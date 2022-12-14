module Day14
    export day14part1, day14part2

    function day14part1(s)
        paths = parsepaths(s)
        cave = drawrocks(paths)
        count = 0
        while addsand!(cave)
            count += 1
        end
        # showcave(cave)
        count
    end

    function day14part2(s)
        paths = parsepaths(s)
        cave = drawrocks(paths)
        drawfloor!(cave)
        count = 1
        while addsand2!(cave)
            count += 1
        end
        # showcave(cave)
        count
    end

    function parsepaths(s)
        map(parsepath, split(strip(s), '\n'))
    end

    function parsepath(line)
        hcat(map(s -> map(n -> parse(Int, n), split(s, ',')), split(line, " -> "))...)
    end

    struct Cave
        cavemap::Matrix{Int8}
        offset::Vector{Int}
    end

    function drawrocks(paths)
        # Find the extent of the cave
        minx, maxx = extrema(vcat(map(p -> p[1,:], paths)...))
        miny, maxy = extrema(vcat(map(p -> p[2,:], paths)...))
        
        # Part 2: sand will go to 500 ± height
        miny = 0
        maxy += 2
        h = maxy - miny + 1
        minx = min(minx, 500 - h - 1)
        maxx = max(maxx, 500 + h + 1)
        w = maxx - minx + 1

        cave = zeros(Int8, w, h)
        offset = [minx - 1, miny - 1]
        
        # Draw the paths
        for p in paths
            ncoords = size(p)[2]
            for i in 1:ncoords-1
                from = p[:, i] - offset
                to = p[:, i+1] - offset
                x1, x2 = minmax(from[1], to[1])
                y1, y2 = minmax(from[2], to[2])
                cave[x1:x2,y1:y2] .= 1
            end
        end

        Cave(cave, offset)
    end

    function drawfloor!(cave)
        w, h = size(cave.cavemap)
        cave.cavemap[:, h] .= 1
    end

    function showcave(cave)
        println("x0 = $(cave.offset[1])")
        w, h = size(cave.cavemap)
        for y in 1:h
            for x in 1:w
                v = cave.cavemap[x, y]
                print([' ', '█', '░'][v+1])
            end
            print('\n')
        end
        print('\n')
    end

    function addsand!(cave)
        cmap = cave.cavemap
        w, h = size(cmap)
        x, y = [500, 0] - cave.offset
        while true
            newy = y + 1
            if newy > h # out the bottom
                return false
            elseif cmap[x, newy] == 0 # straight down
                y = newy
            elseif x - 1 < 1 # out the left side
                return false
            elseif cmap[x - 1, newy] == 0 # down one left one
                y = newy
                x = x - 1
            elseif x + 1 > w # out the right side
                return false
            elseif cmap[x + 1, newy] == 0 # down one right one
                y = newy
                x = x + 1
            else
                # everywhere blocked, stay put!
                cmap[x, y] = 2
                return true
            end
        end
    end

    function addsand2!(cave)
        x0, y0 = [500, 0] - cave.offset
        addsand!(cave)
        return cave.cavemap[x0, y0] == 0
    end
end

using .Day14
