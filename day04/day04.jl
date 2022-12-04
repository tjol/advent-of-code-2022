module Day04
    export day04part1, day04part2

    function day04part1(s)
        count(either_is_fully_contained, parseassignments(s))
    end

    function day04part2(s)
        count(have_overlap, parseassignments(s))
    end

    function parseassignments(s)
        map(split(strip(s), '\n')) do line
            map(split(line, ',')) do range
                Tuple(map(s -> parse(Int, s), split(range, '-')))
            end
        end
    end

    function either_is_fully_contained(assignment)
        range1, range2 = assignment
        is_fully_contained(range1, range2) || is_fully_contained(range2, range1)
    end

    function is_fully_contained(range1, range2)
        a, b = range1
        c, d = range2
        c ≤ a ≤ d && c ≤ b ≤ d
    end

    function have_overlap(assignment)
        (a, b), (c, d) = assignment
        a ≤ c ≤ b || a ≤ d ≤ b || c ≤ a ≤ d
    end
end

using .Day04
