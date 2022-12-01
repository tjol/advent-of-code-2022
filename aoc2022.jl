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

checkresult(day01part1, "day01/demoinput", 24000)
checkresult(day01part2, "day01/demoinput", 45000)
printresult(day01part1, "day01/input")
printresult(day01part2, "day01/input")
