#! /usr/bin/env fish


set benchmarks \
    "lambda1" "lambda2" "matrix" "pascal_triangle" "pythagorean_triplet" "sorting" "trees"

for bench in $benchmarks

    set -l cmds
    set -l inputs tests/$bench*.input

    for variation in tests/$bench*.py
        echo $variation
        set -l runtimes "python3" "pypy3"
        set cmds $cmds $runtimes" $variation < "$inputs
    end

    for variation in tests/$bench*.exs
        echo $variation
        set cmds $cmds "elixir $variation <"$inputs
    end

    for variation in tests/$bench*.frl
        echo $variation
        set -l benchname (basename $variation .frl)

        if test ! -e tests/$benchname.exe
            echo "Building code for $variation"
            dune exec ./src/cli/lcc.exe < $variation > tests/$benchname.c 2> /dev/null
            gcc -O3 tests/$benchname.c -o tests/$benchname.nogc.exe
            gcc -O3 tests/$benchname.c -o tests/$benchname.exe -DGC -lgc
        end

        set cmds $cmds "./tests/$benchname"{.exe,.nogc.exe}" < "$inputs
    end

    set cmds '"'$cmds'"'

    echo "Tests for $bench :"
    echo $cmds
    echo

    if test ! -e "$bench.json"
        # For some reason, hyperfine fails if run directly (!?)
        # note that it only fails inside a fish _script_, not at the prompt (!?)
        # this is stupid but it works...
        bash -c "hyperfine -w 1 --export-json $bench.json --export-markdown $bench-results.md -u millisecond $cmds"
    end
end

