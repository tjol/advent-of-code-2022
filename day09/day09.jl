module Day09
    export day09part1, day09part2

    function day09part1(s)
        rope = RopeState(2)
        movehead!(rope, parsemotions(s))
        length(rope.taillog)
    end

    function day09part2(s)
        rope = RopeState(10)
        movehead!(rope, parsemotions(s))
        length(rope.taillog)
    end

    Motion = Tuple{Char, Int64}

    function parsemotions(s::String)::Vector{Motion}
        map(split(strip(s), '\n')) do line
            dir, scount = split(line)
            icount = parse(Int64, scount)
            (dir[1], icount)
        end
    end

    function motionvector(instruction::Char)::Vector{Int}
        if instruction == 'L'
            [-1, 0]
        elseif instruction == 'R'
            [1, 0]
        elseif instruction == 'U'
            [0, 1]
        elseif instruction == 'D'
            [0, -1]
        end
    end

    mutable struct RopeState
        knots::Matrix{Int}
        taillog::Set{Vector{Int}}
    end

    RopeState(nknots) = RopeState(zeros(Int, 2, nknots), Set([[0, 0]]))

    function movehead!(rope::RopeState, vec::Vector{Int})
        rope.knots[:,1] += vec
        nknots = size(rope.knots)[2]
        for i in 2:nknots
            rope.knots[:, i] = movetail(rope.knots[:, i-1], rope.knots[:, i])
        end
        push!(rope.taillog, copy(rope.knots[:, end]))
    end

    movehead!(rope::RopeState, instruction::Char) = movehead!(rope, motionvector(instruction))

    function movehead!(rope::RopeState, motion::Motion)
        instruction, repeat = motion
        for _ in 1:repeat
            movehead!(rope, instruction)
        end
    end

    function movehead!(rope::RopeState, motions::Vector{Motion})
        for m in motions
            movehead!(rope, m)
        end
    end

    function movetail(head, tail)
        Δ = head - tail
        if maximum(abs.(Δ)) > 1
            # Must move tail
            tail += sign.(Δ)
        end
        tail
    end
end

using .Day09
