module RockPaperScissors

    @enum Throw rock=1 paper=2 scissors=3
    @enum GameResult loss=0 draw=3 win=6

    function decode_elf(encoded)
        if encoded == "A"
            rock
        elseif encoded == "B"
            paper
        elseif encoded == "C"
            scissors
        end
    end

    function decode_part1strat(encoded)
        if encoded == "X"
            rock
        elseif encoded == "Y"
            paper
        elseif encoded == "Z"
            scissors
        end
    end

    function decode_part2strat(encoded)
        if encoded == "X"
            loss
        elseif encoded == "Y"
            draw
        elseif encoded == "Z"
            win
        end
    end

    WINNING_MOVES = [
        (rock, scissors),
        (scissors, paper),
        (paper, rock),
    ]

    function resolve_part2strat(result, theirthrow)
        if result == draw
            theirthrow
        elseif result == loss
            for (a, b) ∈ WINNING_MOVES
                if a == theirthrow
                    return b
                end
            end
        else
            for (a, b) ∈ WINNING_MOVES
                if b == theirthrow
                    return a
                end
            end
        end
    end

    function gameresult(mythrow, theirthrow)
        for (a, b) ∈ WINNING_MOVES
            if a == mythrow && b == theirthrow
                return win
            elseif a == theirthrow && b == mythrow
                return loss
            end
        end
        return draw
    end

    function score(mythrow, theirthrow)
        Int(gameresult(mythrow, theirthrow)) + Int(mythrow)
    end

end

import .RockPaperScissors

function day02part1(s)
    score = 0
    for line in split(strip(s), '\n')
        a, b = split(line, ' ')
        theirthrow = RockPaperScissors.decode_elf(a)
        mythrow = RockPaperScissors.decode_part1strat(b)
        score += RockPaperScissors.score(mythrow, theirthrow)
    end
    score
end

function day02part2(s)
    score = 0
    for line in split(strip(s), '\n')
        a, b = split(line, ' ')
        theirthrow = RockPaperScissors.decode_elf(a)
        mystrat = RockPaperScissors.decode_part2strat(b)
        mythrow = RockPaperScissors.resolve_part2strat(mystrat, theirthrow)
        score += RockPaperScissors.score(mythrow, theirthrow)
    end
    score
end
