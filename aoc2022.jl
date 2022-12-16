# Advent of Code 2022 entry point

function getresult(f, inputfile::String)
    if inputfile == "-"
        getresult(f, stdin)
    else
        open(io -> getresult(f, io), inputfile, "r")
    end
end

function getresult(f, inputio::IO)
    text = read(inputio, String)
    if Sys.iswindows()
        text = replace(text, "\r\n" => "\n")
    end
    f(text)
end

function checkresult(f, input, expected)
    result = getresult(f, input)
    if result ≠ expected
        error("Got $result, expected $expected ($input, $f)")
    end
end

function printresult(f, input)
    println("$f [$input] -> $(getresult(f, input))")
end

include("day01/day01.jl")
include("day02/day02.jl")
include("day03/day03.jl")
include("day04/day04.jl")
include("day05/day05.jl")
include("day06/day06.jl")
include("day07/day07.jl")
include("day08/day08.jl")
include("day09/day09.jl")
include("day10/day10.jl")
include("day11/day11.jl")
include("day12/day12.jl")
include("day13/day13.jl")
include("day14/day14.jl")
include("day15/day15.jl")

function run(day)
    if day == 1
        checkresult(day01part1, "day01/demoinput", 24000)
        checkresult(day01part2, "day01/demoinput", 45000)
        printresult(day01part1, "day01/input")
        printresult(day01part2, "day01/input")
    elseif day == 2
        checkresult(day02part1, "day02/demoinput", 15)
        checkresult(day02part2, "day02/demoinput", 12)
        printresult(day02part1, "day02/input")
        printresult(day02part2, "day02/input")
    elseif day == 3
        checkresult(day03part1, "day03/demoinput", 157)
        checkresult(day03part2, "day03/demoinput", 70)
        printresult(day03part1, "day03/input")
        printresult(day03part2, "day03/input")
    elseif day == 4
        checkresult(day04part1, "day04/demoinput", 2)
        checkresult(day04part2, "day04/demoinput", 4)
        printresult(day04part1, "day04/input")
        printresult(day04part2, "day04/input")
    elseif day == 5
        checkresult(day05part1, "day05/demoinput", "CMZ")
        checkresult(day05part2, "day05/demoinput", "MCD")
        printresult(day05part1, "day05/input")
        printresult(day05part2, "day05/input")
    elseif day == 6
        checkresult(day06part1, "day06/demoinput1", 7)
        checkresult(day06part1, "day06/demoinput2", 5)
        checkresult(day06part2, "day06/demoinput1", 19)
        checkresult(day06part2, "day06/demoinput2", 23)
        printresult(day06part1, "day06/input")
        printresult(day06part2, "day06/input")
    elseif day == 7
        checkresult(day07part1, "day07/demoinput", 95437)
        checkresult(day07part2, "day07/demoinput", 24933642)
        printresult(day07part1, "day07/input")
        printresult(day07part2, "day07/input")
    elseif day == 8
        checkresult(day08part1, "day08/demoinput", 21)
        checkresult(day08part2, "day08/demoinput", 8)
        printresult(day08part1, "day08/input")
        printresult(day08part2, "day08/input")
    elseif day == 9
        checkresult(day09part1, "day09/demoinput", 13)
        checkresult(day09part2, "day09/demoinput", 1)
        printresult(day09part1, "day09/input")
        printresult(day09part2, "day09/input")
    elseif day == 10
        checkresult(day10part1, "day10/demoinput", 13140)
        printresult(day10part1, "day10/input")
        printresult(day10part2, "day10/input")
    elseif day == 11
        checkresult(day11part1, "day11/demoinput", 10605)
        checkresult(day11part2, "day11/demoinput", 2713310158)
        printresult(day11part1, "day11/input")
        printresult(day11part2, "day11/input")
    elseif day == 12
        checkresult(day12part1, "day12/demoinput", 31)
        checkresult(day12part2, "day12/demoinput", 29)
        printresult(day12part1, "day12/input")
        printresult(day12part2, "day12/input")
    elseif day == 13
        checkresult(day13part1, "day13/demoinput", 13)
        checkresult(day13part2, "day13/demoinput", 140)
        printresult(day13part1, "day13/input")
        printresult(day13part2, "day13/input")
    elseif day == 14
        checkresult(day14part1, "day14/demoinput", 24)
        checkresult(day14part2, "day14/demoinput", 93)
        printresult(day14part1, "day14/input")
        printresult(day14part2, "day14/input")
    elseif day == 15
        checkresult(s -> day15part1(s, 10), "day15/demoinput", 26)
        checkresult(day15part2, "day15/demoinput", 56000011)
        printresult(day15part1, "day15/input")
        printresult(day15part2, "day15/input")
    end
end

if length(ARGS) == 0
    for day in 1:25
        run(day)
    end
elseif length(ARGS) == 1
    day = parse(Int, ARGS[1])
    run(day)
else
    error("Require 0 or 1 args")
end
