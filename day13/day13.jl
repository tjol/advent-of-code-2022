module Day13
    export day13part1, day13part2

    function day13part1(s)
        pairs = parsepairs(s)
        correctindexsum = 0
        for (i, (a, b)) in enumerate(pairs)
            if cmpdistress(a, b) <= 0
                correctindexsum += i
            end
        end
        correctindexsum
    end

    function day13part2(s)
        packets = map(parseintorlist, filter(!=(0) ∘ length, split(s, '\n')))
        # Add in dividers
        dividers = [parseintorlist("[[2]]"), parseintorlist("[[6]]")]
        append!(packets, dividers)
        # Sort
        sort!(packets, lt=lessdistress)
        # Locate dividers
        divs = 1
        for (i, p) in enumerate(packets)
            if p in dividers
                divs *= i
            end
        end
        divs
    end

    struct IntOrList
        value::Union{Int, Vector{IntOrList}}
    end

    Base.show(io::IO, iol::IntOrList) = Base.show(io, iol.value)
    
    cmpdistress(a::Int, b::Int) = cmp(a, b)
    cmpdistress(a::Int, b::Vector{IntOrList}) = cmpdistress([IntOrList(a)], b)
    cmpdistress(a::Vector{IntOrList}, b::Int) = cmpdistress(a, [IntOrList(b)])
    cmpdistress(a::IntOrList, b::IntOrList) = cmpdistress(a.value, b.value)

    lessdistress(a, b) = cmpdistress(a, b) < 0

    function cmpdistress(a::Vector{IntOrList}, b::Vector{IntOrList})
        for (a1, b1) in zip(a, b)
            c = cmpdistress(a1, b1)
            if c != 0
                return c
            end
        end
        cmp(length(a), length(b))
    end

    function parsepairs(s)
        lines = split(s, '\n')
        count = (length(lines) + 1) ÷ 3
        [(parseintorlist(lines[3*i+1]), parseintorlist(lines[3*i+2])) for i in 0:(count-1)]
    end

    function takeintorlist(s)
        if s[1] == '['
            # List
            lst::Vector{IntOrList} = []
            rest = s[2:end]
            while rest[1] != ']'
                elem, rest = takeintorlist(rest)
                if rest[1] == ','
                    rest = rest[2:end]
                end
                push!(lst, elem)
            end
            return (IntOrList(lst), rest[2:end])
        else
            # Int
            pastend = findfirst(r"[^0-9]", s)[1]
            rest = s[pastend:end]
            return (IntOrList(parse(Int, s[1:pastend-1])), rest)
        end
    end

    parseintorlist(s) = takeintorlist(s)[1]
end

using .Day13
