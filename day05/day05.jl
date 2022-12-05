module Day05
    export day05part1, day05part2

    function day05part1(s)
        stacks, instructions = parse_day5(s)
        cratemover9000!(stacks, instructions)
        topcrates(stacks)
    end

    function day05part2(s)
        stacks, instructions = parse_day5(s)
        cratemover9001!(stacks, instructions)
        topcrates(stacks)
    end

    struct Instruction
        quantity::Int
        from::Int
        to::Int
    end

    function parse_day5(s)
        lines = split(s, '\n')
        idx_colline = findfirst(i -> '[' ∉ lines[i], 1:length(lines))
        nstacks = maximum(map(s -> parse(Int, strip(s)), split(lines[idx_colline])))
        stacks = parse_stacks(nstacks, lines[1:idx_colline-1])
        instructions = parse_instructions(lines[idx_colline+2:end])
        stacks, instructions
    end

    function parse_stacks(nstacks, lines)
        stacks = [Char[] for _ ∈ 1:nstacks]
        for line ∈ lines
            for istack ∈ 1:nstacks
                ichr = 4 * istack - 2
                if length(line) > ichr && line[ichr] ≠ ' '
                    pushfirst!(stacks[istack], line[ichr])
                end
            end
        end
        stacks
    end

    function parse_instructions(lines)
        re = r"move (\d+) from (\d+) to (\d+)"
        map(filter(l -> l ≠ "", lines)) do line
            m = match(re, line)
            Instruction(
                parse(Int, m.captures[1]),
                parse(Int, m.captures[2]),
                parse(Int, m.captures[3]))
        end
    end

    function cratemover9000!(stacks, instructions)
        for instruction ∈ instructions
            for _ ∈ 1:instruction.quantity
                move!(stacks, instruction.from, instruction.to)
            end
        end
    end

    function cratemover9001!(stacks, instructions)
        for instruction ∈ instructions
            q = instruction.quantity
            from = stacks[instruction.from]
            crates = from[end-q+1:end]
            resize!(from, length(from) - q)
            append!(stacks[instruction.to], crates)
        end
    end

    function move!(stacks, from, to)
        crate = pop!(stacks[from])
        push!(stacks[to], crate)
    end

    function topcrates(stacks)
        join([stack[end] for stack ∈ stacks])
    end
end

using .Day05
