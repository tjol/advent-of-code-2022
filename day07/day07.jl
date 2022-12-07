module Day07
    export day07part1, day07part2

    function day07part1(s)
        commands = parse_terminal_output(s)
        rootdir = Directory("", nothing, [], [], 0)
        replay!(commands, rootdir)
        recalc_sizes!(rootdir)
        # pprinttree(rootdir)
        sum(map(d -> d.size, filter(d -> d.size ≤ 100000, alldirs(rootdir))))
    end

    function day07part2(s)
        commands = parse_terminal_output(s)
        rootdir = Directory("", nothing, [], [], 0)
        replay!(commands, rootdir)
        recalc_sizes!(rootdir)

        totalspace = 70000000
        usedspace = rootdir.size
        requiredspace = 30000000
        freespace = totalspace - usedspace
        missingspace = requiredspace - freespace

        bigenough = filter(d -> d.size >= missingspace, alldirs(rootdir))
        sizes = map(d -> d.size, bigenough)
        minimum(sizes)
    end

    struct Command
        command::Vector{String}
        output::Vector{String}
    end

    function parse_terminal_output(s)
        commands::Vector{Command} = []
        for line in split(s, '\n')
            if startswith(line, '$')
                # This is a command
                push!(commands, Command(map(strip, split(line[2:end])), []))
            else
                # This is a line of output
                push!(commands[end].output, line)
            end
        end
        commands
    end

    struct SizedFile
        name::String
        size::UInt64
    end

    mutable struct Directory
        name::String
        parent::Union{Directory, Nothing}
        subdirs::Vector{Directory}
        files::Vector{SizedFile}
        size::UInt64
    end

    function replay!(commands, rootdir)
        cwd = rootdir
        for cmd in commands
            if cmd.command[1] == "cd"
                # Change directory
                dest = cmd.command[2]
                if dest == "/"
                    cwd = rootdir
                elseif dest == ".."
                    cwd = cwd.parent
                else
                    # Find the child (assume it exists)
                    for subdir in cwd.subdirs
                        if subdir.name == dest
                            cwd = subdir
                            break
                        end
                    end
                end
            elseif cmd.command[1] == "ls"
                # Parse file list
                cwd.subdirs = []
                cwd.files = []
                for lsline in cmd.output
                    sizestr, name = split(lsline)
                    if sizestr == "dir"
                        push!(cwd.subdirs, Directory(name, cwd, [], [], 0))
                    else
                        size = parse(UInt64, sizestr)
                        push!(cwd.files, SizedFile(name, size))
                    end
                end
            else
                error("Unknown command $(cmd.command[1])")
            end
        end
    end

    function recalc_sizes!(dir)
        for subdir in dir.subdirs
            recalc_sizes!(subdir)
        end
        dir.size = sum(map(f -> f.size, dir.files)) + sum(map(d -> d.size, dir.subdirs))
    end

    function alldirs(dir)
        dirs = [dir]
        for subdir in dir.subdirs
            append!(dirs, alldirs(subdir))
        end
        dirs
    end

    function pprinttree(dir)
        pprinttree(dir, "")
    end

    function pprinttree(dir, indent)
        println("$(indent)$(dir.name)/ ($(dir.size))")
        for subdir in dir.subdirs
            pprinttree(subdir, "$(indent)  ")
        end
        for f in dir.files
            println("$(indent)  $(f.name) ($(f.size))")
        end
    end
end

using .Day07
