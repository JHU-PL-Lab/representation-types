
from contextlib import contextmanager
from collections import defaultdict
import json
import sys
import os

class dotdict(dict):
    def __getattr__(self, field):
        return self.__getitem__(field)
    def __setattr__(self, field, value):
        self.__setitem__(field, value)

@contextmanager
def env(name, etc = None):
    print(rf"\begin{{{name}}}", end="")
    if etc:
        print(etc, end="")
    print()
    yield
    print(rf"\end{{{name}}}")



def print_table(input, display_name, benches):

    with env("table"):
        with env("tabular", "{ | l | r @{\;$\pm$\;} l | r | r | r | }"):
            print("\hline")
            print(rf" Program & Mean & Std Dev & Min & Max & Ratio to best \\")
            print("\hline\hline")

            for b in benches:
                print(b.exe, end=" ")
                if b.runtime:
                    print(f"({b.runtime}) ", end="")
                if b.best:
                    print(rf"& \textbf{{{b.mean:2.2f}}} & \textbf{{{b.stddev:2.2f}}}", end="")
                else:
                    print(rf"& {b.mean:2.2f} & {b.stddev:2.2f} ", end="")
                print(rf"& {b.min:2.2f} & {b.max:2.2f} ", end="")
                print(rf"& {b.ratio:2.2f} \\")
                print("\hline")
        print(rf"\caption{{\label{{tab:{input}}}{display_name}}}")
            

def bench_results(d):
    inputs  = []
    benches = []

    for bench in d["results"]:
        bench = dotdict(bench)
        
        cmd = bench.command.split("<")
        exe, runtime, *_ = *cmd[0].strip("./ ").split()[::-1], None
        
        inp = os.path.basename(cmd[1].strip()).replace("_", "-")
        inputs.append(inp)

        bench.name    = inp.split(".")[0]
        bench.input   = inp
        bench.exe     = os.path.basename(exe).replace("_", "-")
        bench.runtime = runtime or "us" # ("us.nogc" if "nogc" in bench.exe else "us")
        bench.min    *= 1000
        bench.max    *= 1000
        bench.mean   *= 1000
        bench.median *= 1000
        bench.stddev *= 1000
        benches.append(bench)


    bests = defaultdict(lambda: float("inf"))
    for bench in benches:
        bests[bench.input] = min(bench.mean, bests[bench.input])

    for bench in benches:
        best = bests[bench.input]
        bench.ratio = bench.mean /  best
        bench.best  = bench.mean == best

    return benches


def print_results(d):

    bench_by_input = defaultdict(list)
    for result in bench_results(d):
        bench_by_input[result.input].append(result)
    
    for input, benches in bench_by_input.items():
        
        benches.sort(key = lambda b: (b.exe, b.runtime))

        input_parts = input.split(".")
        display_name = f"``{input_parts[0].replace('-', ' ').capitalize()}''"
        if len(input_parts) == 3:
            display_name = f"{display_name} ({input_parts[1]})"

        print_table(input, display_name, benches)


def mean(l):
    return sum(l) / len(l)

def summarize_results(ds):

    results_by_bench_runtime = defaultdict(lambda: defaultdict(list))
    ratios_by_bench_runtime  = defaultdict(lambda: defaultdict(list))
    results_by_input_runtime = defaultdict(lambda: defaultdict(list))
    ratios_by_input_runtime  = defaultdict(lambda: defaultdict(list))
    ratios_by_runtime        = defaultdict(list)

    for d in ds:
        for result in bench_results(d):
            results_by_bench_runtime[result.name][result.runtime].append(result)
            ratios_by_bench_runtime[result.name][result.runtime].append(result.ratio)
            results_by_input_runtime[result.input][result.runtime].append(result)
            ratios_by_input_runtime[result.input][result.runtime].append(result.ratio)
            ratios_by_runtime[result.runtime].append(result.ratio)

    runtimes = ["python3", "pypy3", "elixir", "us"] # , "us.nogc"]

    with env("table"):
        with env("tabular", "{ | r || r | r | r | r | }"):
            print("\cline{2-5}")
            print(r"\multicolumn{1}{c||}{} & CPython & Pypy3 & Elixir & This Work \\")
            print("\hline")
            for name, results_by_runtime in results_by_bench_runtime.items():
                print(rf"{name.capitalize()} ", end="")
                avg_ratios = {runtime : mean(ratios_by_bench_runtime[name][runtime]) for runtime in runtimes}
                min_ratio  = min(avg_ratios.values()) 
                for runtime in runtimes:
                    avg_ratio = avg_ratios[runtime]
                    if avg_ratio == min_ratio:
                        print(rf"& \textbf{{{avg_ratio:2.3f}}} ", end="")
                    else:
                        print(rf"& {avg_ratio:2.3f} ", end="")
                print(r"\\")
                print("\hline")

        print(rf"\caption{{\label{{tab:benchmark-summary}}Overall summary (average ratio to best)}}")


    with env("table"):
        with env("tabular", "{ | r || r | r | r | r | }"):
            print("\cline{2-5}")
            print(r"\multicolumn{1}{c||}{} & CPython & Pypy3 & Elixir & This Work \\")
            print("\hline")
            for input, results_by_runtime in results_by_input_runtime.items():
                input_parts = input.split(".")
                display_name = input_parts[0].replace('-', ' ').capitalize()
                if len(input_parts) == 3:
                    display_name = f"{display_name} ({input_parts[1]})"

                print(rf"{display_name} ", end="")
                avg_ratios = {runtime : mean(ratios_by_input_runtime[input][runtime]) for runtime in runtimes}
                min_ratio  = min(avg_ratios.values()) 
                for runtime in runtimes:
                    avg_ratio = avg_ratios[runtime]
                    if avg_ratio == min_ratio:
                        print(rf"& \textbf{{{avg_ratio:2.3f}}} ", end="")
                    else:
                        print(rf"& {avg_ratio:2.3f} ", end="")
                print(r"\\")
                print("\hline")

        print(rf"\caption{{\label{{tab:benchmark-summary2}}Summary by input condition (average ratio to best)}}")


if __name__ == "__main__":
    if sys.argv[1] == "individual":
        for in_filename in sys.argv[2:]:
            with open(in_filename, "r") as f:
                print_results(json.load(f))
    elif sys.argv[1] == "summary":
        dumps = []
        for in_filename in sys.argv[2:]:
            with open(in_filename, "r") as f:
                dumps.append(json.load(f))
        summarize_results(dumps)





