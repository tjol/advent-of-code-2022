module Day10
    export day10part1, day10part2

    function day10part1(s)
        vals = simulate(s)
        sum([i * vals[i] for i in [20, 60, 100, 140, 180, 220]])
    end

    function day10part2(s)
        vals = simulate(s)
        "\n" * draw(vals) * "\n"
    end

    function simulate(s)
        cur = 1
        vals::Vector{Int} = []
        for line in split(strip(s), '\n')
            if line[1:4] == "noop"
                push!(vals, cur)
            elseif line[1:4] == "addx"
                v = parse(Int, line[6:end])
                append!(vals, [cur, cur])
                cur += v
            else
                error("Parse error: $(line)")
            end
        end
        vals
    end

    function draw(vals)
        display = ""

        rows = length(vals) ÷ 40
        statematrix = reshape(vals, 40, rows)
        x = repeat(1:40, 1, rows)
        lit = abs.(statematrix - x .+ 1) .<= 1
        for y in 1:rows
            for x in 1:40
                if lit[x, y]
                    display = display * "█"
                else
                    display = display * " "
                end
            end
            display = display * "\n"
        end
        
        display
    end
end

using .Day10
