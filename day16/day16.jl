module Day16
    export day16part1, day16part2

    function day16part1(s)
        valves = Dict([(v.key, v) for v in map(parsevalve, split(strip(s), '\n'))])
        simplifygraph!(valves)
        # printgraph(valves)

        states = Dict([(k, Vector{VolcanoState}()) for k in keys(valves)])
        initial = VolcanoState(30, 0, 0x4141, [])
        push!(states[0x4141], initial)
        queue = [initial]

        i = 0
        while !isempty(queue)
            state = popfirst!(queue)
            # @show state
            moves = getmoves(valves, state)
            for move in moves
                # Is this move sensible?
                rejected = false
                for oldstate in states[move.position]
                    if oldstate.time_remaining > move.time_remaining && oldstate.pressure_released >= move.pressure_released
                        # Have a faster path to this state!
                        rejected = true
                    end
                end
                if !rejected
                    push!(states[move.position], move)
                    push!(queue, move)                    
                end
            end
            i += 1
        end

        # Find the best
        maximum(map(lst -> maximum(map(s -> s.pressure_released, lst)), values(states)))
    end

    function day16part2(s)
    end

    struct Valve
        key::UInt16
        flow::Int
        tunnels::Dict{UInt16, UInt16}
    end

    function keytou16(keystring)
        @assert length(keystring) == 2
        (UInt16(keystring[1]) << 8) | UInt16(keystring[2])
    end

    function u16tokeystring(key)
        Char(key >> 8) * Char(key & 0xff)
    end

    function parsevalve(line)
        m = match(r"Valve ([A-Z]{2}) has flow rate=([0-9]+); tunnels? leads? to valves? ([A-Z, ]+)", line)
        key = keytou16(m.captures[1])
        flow = parse(Int, m.captures[2])
        tunnels = Dict(map(key -> (keytou16(key), 1), split(m.captures[3], ", ")))
        Valve(key, flow, tunnels)
    end

    function simplifygraph!(valves)
        # Get all flow-less valves
        zerovalves = [key for (key, v) in valves if v.flow == 0 && key != 0x4141] # 4141 is AA

        # Remove all flow-less valves from the graph
        for key in zerovalves
            v = pop!(valves, key)
            for (dest, dist) in v.tunnels
                othervalve = valves[dest]
                theirtunnels = othervalve.tunnels
                delete!(theirtunnels, key)
                for (dest2, dist2) in v.tunnels
                    if dest2 != dest
                        if haskey(theirtunnels, dest2)
                            theirtunnels[dest2] = min(dist + dist2, theirtunnels[dest2])
                        else
                            theirtunnels[dest2] = dist + dist2
                        end
                    end
                end
            end
        end
    end

    function printgraph(valves)
        for (k, v) in valves
            print("$(u16tokeystring(k)) [$(v.flow)] ;")
            for (dest, dist) in v.tunnels
                print("; $(u16tokeystring(dest)) ($dist)")
            end
            println()
        end
    end

    struct VolcanoState
        time_remaining::Int
        pressure_released::Int
        position::UInt16
        opened::Vector{UInt16}
    end

    function getmoves(valves, state)
        moves = []
        pos = state.position
        valve = valves[pos]
        # Can I open the valve?
        if pos ∉ state.opened && valve.flow != 0
            flow = valve.flow
            release = flow * (state.time_remaining - 1)
            push!(moves, VolcanoState(state.time_remaining - 1,
                                      state.pressure_released + release,
                                      pos,
                                      vcat(state.opened, [pos])))
        end
        # Can I go somewhere?
        for (dest, dist) in valve.tunnels
            if dist < state.time_remaining
                push!(moves, VolcanoState(state.time_remaining - dist,
                                          state.pressure_released,
                                          dest,
                                          state.opened))
            end
        end
        moves
    end
end

using .Day16
