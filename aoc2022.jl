# Advent of Code 2022 entry point

function getresult(f, inputfile::String)
    if inputfile == "-"
        getresult(f, stdin)
    else
        open(io -> getresult(f, io), inputfile, "r")
    end
end

function getresult(f, inputio::IO)
    f(read(inputio, String))
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
