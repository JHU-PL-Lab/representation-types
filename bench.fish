#! /usr/bin/env fish


set benchmarks \
    "lambda1" "lambda2" "matrix" "pascal_triangle" "pythagorean_triplet" "sorting" "trees"

for bench in $benchmarks

    set -l result_files "$bench"*.json
    if test ! -z "$result_files"
        echo "Files already present for: `$bench`"
        continue
    end

    set -l cmds
    set -l inputs tests/$bench*.input

    for variation in tests/$bench*.py
        echo $variation
        set -l runtimes "python3" "pypy3"
        set cmds $cmds $runtimes" $variation"
    end

    for variation in tests/$bench*.exs
        echo $variation
        set cmds $cmds "elixir $variation"
    end

    for variation in tests/$bench*.frl
        echo $variation
        set -l benchname (basename $variation .frl)

        if test ! -e tests/$benchname.exe
            echo "Building code for $variation"
            dune exec ./src/cli/lcc.exe < $variation > tests/$benchname.c 2> /dev/null
            gcc -g -O3 tests/$benchname.c -o tests/$benchname.exe -DGC -lgc
        end

        set cmds $cmds "./tests/$benchname.exe"
    end


    for input in $inputs 
        set -l condition (basename $input ".input")
        set -l input_cmds $cmds" < "$input
        set -l input_cmds '"'$input_cmds'"'
         
        echo "Tests for $bench :"
        echo $input_cmds
        echo

        # For some reason, hyperfine fails if run directly (!?)
        # note that it only fails inside a fish _script_, not at the prompt (!?)
        # this is stupid but it works...
        bash -c "hyperfine -w 1 --export-json $condition.json --export-markdown $bench-results.md -u millisecond $input_cmds"
    end
end

