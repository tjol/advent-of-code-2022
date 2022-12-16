module Day15
    export day15part1, day15part2

    function day15part1(s, row=2000000)
        sensors = parsesensors(s)
        ranges = map(sensor -> sensorrange(sensor, row), sensors)
        merged = mergeranges(ranges)
        sum(map(range -> range[2] - range[1], merged))
    end

    function day15part2(s)
        sensors = parsesensors(s)
        for y in 0:4000000
            ranges = map(sensor -> sensorrange(sensor, y), sensors)
            merged = mergeranges(ranges)
            minx = 0
            maxx = 4000000
            for (x1, x2) in merged
                if x1 > minx
                    return 4000000 * minx + y
                elseif x2 ≥ maxx
                    break
                else
                    minx = x2 + 1
                end
            end
        end
    end

    struct Sensor
        pos::Vector{Int}
        beacon::Vector{Int}
        dist::Int
    end

    function parsesensor(line)
        m = match(r"Sensor at x=(-?[0-9]+), y=(-?[0-9]+): closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)", line)
        g = m.captures
        pos = [parse(Int, g[1]), parse(Int, g[2])]
        beacon = [parse(Int, g[3]), parse(Int, g[4])]
        dist = sum(abs.(pos - beacon))
        Sensor(pos, beacon, dist)
    end

    function parsesensors(s)
        map(parsesensor, split(strip(s), '\n'))
    end

    function sensorrange(sensor, y)
        x0, y0 = sensor.pos
        Δy = abs(y0 - y)
        Δx = sensor.dist - Δy
        (x0 - Δx, x0 + Δx)
    end

    function mergeranges(ranges)
        if isempty(ranges)
            return []
        end
        ranges = sort(ranges)
        result = []
        left, right = ranges[1]
        for (x1, x2) in ranges[2:end]
            if x2 ≤ right
                # already included
            elseif x1 ≤ right + 1
                # partial overlap or adjacent
                right = x2
            else
                # no overlap
                push!(result, (left, right))
                left, right = x1, x2
            end
        end
        push!(result, (left, right))
        result
    end
end

using .Day15
