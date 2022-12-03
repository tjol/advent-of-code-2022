module Day03
    export day03part1, day03part2

    function day03part1(s)
        sum = 0
        for rucksack ∈ map(strip, split(strip(s), '\n'))
            dup = finddup(rucksack)
            sum += prio(dup)
        end
        sum
    end

    function finddup(rucksack)
        mid = Int(length(rucksack) / 2)
        compartment1 = rucksack[1:mid]
        compartment2 = rucksack[mid+1:end]
        for thing ∈ compartment1
            if thing ∈ compartment2
                return thing
            end
        end
    end

    function prio(thing)
        if 'a' ≤ thing ≤ 'z'
            thing - 'a' + 1
        else
            thing - 'A' + 27
        end
    end

    function day03part2(s)
        rucksacks = map(strip, split(strip(s), '\n'))
        groupcount = Int(length(rucksacks) / 3)
        groupmatrix = reshape(rucksacks, (3, groupcount))
        sum = 0
        for group ∈ eachcol(groupmatrix)
            badge = findbadge(group)
            sum += prio(badge)
        end
        sum
    end

    function findbadge(rucksacks)
        # Find the first thing that's in all three bags
        for thing in join(rucksacks)
            if [true, true, true] == [thing ∈ bag for bag ∈ rucksacks]
                return thing
            end
        end
    end
end

using .Day03
