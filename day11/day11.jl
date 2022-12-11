module Day11
    export day11part1, day11part2

    struct Monkey
        starting::Vector{Int}
        operation::Function
        divtest::Int
        iftrue::Int
        iffalse::Int
    end

    function day11part1(s)
        monkeys = parsemonkeys(s)
        inventories = [m.starting for m in monkeys]
        throw! = (monkey, item) -> push!(inventories[monkey+1], item)

        # Play for 20 rounds
        counters = zeros(Int, length(monkeys))
        for round in 1:20
            for i in 1:lastindex(monkeys)
                inventory = inventories[i]
                counters[i] += length(inventory)
                inventories[i] = []
                playwithitems(monkeys[i], inventory, throw!)
            end
        end

        # Find the two most active monkeys
        sort!(counters)
        counters[end] * counters[end-1]
    end

    function day11part2(s)
        monkeys = parsemonkeys(s)
        inventories = [m.starting for m in monkeys]
        throw! = (monkey, item) -> push!(inventories[monkey+1], item)

        # Find the right mod space to work in
        modulo = lcm([m.divtest for m in monkeys]...)

        # Play for 10000 rounds
        counters = zeros(Int, length(monkeys))
        for round in 1:10000
            for i in 1:lastindex(monkeys)
                inventory = inventories[i]
                counters[i] += length(inventory)
                inventories[i] = []
                playwithitems2(modulo, monkeys[i], inventory, throw!)
            end
        end

        # Find the two most active monkeys
        sort!(counters)
        counters[end] * counters[end-1]
    end

    function parsemonkeys(s)
        lines = split(strip(s), '\n')
        monkeycount = (length(lines) + 1) ÷ 7 # +1 for the missing empty line at the end
        [parsemonkey(lines[i*7 - 6:i*7 - 1]) for i in 1:monkeycount]
    end

    function parsemonkey(lines)
        starting = map(s -> parse(Int, s), split(lines[2][19:end], ", "))
        operation = begin
            operator = lines[3][24]
            sarg = lines[3][26:end]
            if operator == '*' && sarg == "old"
                x -> x^2
            else
                arg = parse(Int, sarg)
                if operator == '*'
                    x -> arg * x
                else
                    x -> arg + x
                end
            end
        end
        divtest = parse(Int, lines[4][22:end])
        iftrue = parse(Int, lines[5][30:end]) # keep as zero-indexed
        iffalse = parse(Int, lines[6][31:end])
        Monkey(starting, operation, divtest, iftrue, iffalse)
    end

    function playwithitem(monkey, item, throwfunc)
        worry = monkey.operation(item) ÷ 3
        if (worry % monkey.divtest) == 0
            throwfunc(monkey.iftrue, worry)
        else
            throwfunc(monkey.iffalse, worry)
        end
    end

    function playwithitems(monkey, inventory, throwfunc)
        for item in inventory
            playwithitem(monkey, item, throwfunc)
        end
    end

    function playwithitem2(modulo, monkey, item, throwfunc)
        worry = monkey.operation(item) % modulo
        if (worry % monkey.divtest) == 0
            throwfunc(monkey.iftrue, worry)
        else
            throwfunc(monkey.iffalse, worry)
        end
    end

    function playwithitems2(modulo, monkey, inventory, throwfunc)
        for item in inventory
            playwithitem2(modulo, monkey, item, throwfunc)
        end
    end
end

using .Day11
