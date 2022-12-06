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

checkresult(day01part1, "day01/demoinput", 24000)
checkresult(day01part2, "day01/demoinput", 45000)
printresult(day01part1, "day01/input")
printresult(day01part2, "day01/input")

checkresult(day02part1, "day02/demoinput", 15)
checkresult(day02part2, "day02/demoinput", 12)
printresult(day02part1, "day02/input")
printresult(day02part2, "day02/input")

checkresult(day03part1, "day03/demoinput", 157)
checkresult(day03part2, "day03/demoinput", 70)
printresult(day03part1, "day03/input")
printresult(day03part2, "day03/input")

checkresult(day04part1, "day04/demoinput", 2)
checkresult(day04part2, "day04/demoinput", 4)
printresult(day04part1, "day04/input")
printresult(day04part2, "day04/input")

checkresult(day05part1, "day05/demoinput", "CMZ")
checkresult(day05part2, "day05/demoinput", "MCD")
printresult(day05part1, "day05/input")
printresult(day05part2, "day05/input")

checkresult(day06part1, "day06/demoinput1", 7)
checkresult(day06part1, "day06/demoinput2", 5)
checkresult(day06part2, "day06/demoinput1", 19)
checkresult(day06part2, "day06/demoinput2", 23)
printresult(day06part1, "day06/input")
printresult(day06part2, "day06/input")
