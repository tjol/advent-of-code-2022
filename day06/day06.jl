module Day06
    export day06part1, day06part2

    function day06part1(s)
        first_unique_sequence(s, 4)
    end

    function day06part2(s)
        first_unique_sequence(s, 14)
    end

    function first_unique_sequence(s, len)
        for i ∈ 1:length(s) - (len - 1)
            if uniquechars(s[i:i + len - 1])
                return i + len - 1
            end
        end
    end

    function uniquechars(s)
        length(Set(s)) == length(s)
    end
end

using .Day06
