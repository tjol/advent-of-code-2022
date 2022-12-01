function day01part1(s)
    max_elf = 0
    this_elf = 0
    for line in map(strip, split(s, '\n'))
        if line == ""
            max_elf = max(max_elf, this_elf)
            this_elf = 0
        else
            this_elf += parse(Int32, line)
        end
    end
    max_elf = max(max_elf, this_elf)
    max_elf
end

function day01part2(s)
    elves = []
    this_elf = 0
    for line in map(strip, split(s, '\n'))
        if line == ""
            append!(elves, this_elf)
            this_elf = 0
        else
            this_elf += parse(Int32, line)
        end
    end
    append!(elves, this_elf)
    sort!(elves)
    sum(elves[end-2:end])
end

