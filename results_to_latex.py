
from operator       import itemgetter, attrgetter
from more_itertools import mark_ends
from itertools      import groupby
from typing         import List, Dict, Tuple, Optional
from dataclasses    import dataclass, field
from contextlib     import contextmanager
from collections    import defaultdict, OrderedDict
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



default_colors = {
    "Elixir": "blue",
    "Pypy3": "black",
    "Python3": "magenta",
    "Us": "green",
}


def row(*strs):
    print(" & ".join(strs), end="")

def multi_column(n, arg, *strs):
    strs = " & ".join(strs)
    return rf"\multicolumn{{{n}}}{arg}{{{strs}}}"

def multi_row(n, str):
    return rf"\multirow{{{n}}}{{*}}{{{str}}}"

def continue_row(*strs):
    row("", *strs)

def end_row():
    print(r"\\")

def hline():
    print(r"\hline")

def toprule():
    print(r"\toprule")

def midrule():
    print(r"\midrule")

def bottomrule():
    print(r"\bottomrule")

def bold(str):
    return rf"\textbf{{{str}}}"

def bold_if(b, *strs):
    return map(bold, strs) if b else strs

def add_plot_coordinates(color, coords):
    coord_str = "".join(str(c) for c in coords)
    print(rf"\addplot[smooth, mark=*, color={color}] coordinates {{{coord_str}}};")

def add_bar_coordinates(color, coords):
    coord_str = "".join(str(c) for c in coords)
    print(rf"\addplot[fill={color}, color={color}] coordinates {{{coord_str}}};")

def add_legend(labels):
    labels_str = ",".join(labels)
    print(rf"\legend{{{labels_str}}}")

def fill_between(label1, label2, color):
    print(rf"\addplot[{color}!80, fill opacity=0.5] fill between[of={label1} and {label2}];")

def caption_figure(text):
    print(rf"\caption{{{text}}}")

def label_figure(label):
    print(rf"\label{{{label}}}")


@dataclass
class ResultsManager:
    # (bench, input_size, runtime, condition) -> details
    entries : dict[tuple, list] = field(default_factory=dict) 

    def ingest(self, file_json):
        results = bench_results(file_json)
        for result in results:
            id = (result.name, result.input or "n/a", result.runtime, result.cond)
            self.entries[id] = result

    
    def print_table(self):

        entries = [(*k, v) for (k, v) in self.entries.items()]
        entries.sort(key=lambda e: e[:2])

        with env("tabular", "{ l l l l r @{\;$\pm$\;} l r r r }"):
            
            row("Benchmark", "Runtime", "(Condition)", "(Input Size)", "Mean", "Std Dev (ms)", "Ratio to best")
            end_row()
            toprule()

            for (name, named_entries) in groupby(entries, itemgetter(0)):
                
                for (size, sized_entries) in groupby(named_entries, itemgetter(1)):
                    midrule()    
                    sized_entries = list(sized_entries)
                    n_entries = len(sized_entries)

                    sized_entries = iter(sized_entries)
                    name, size, runtime, cond, info = next(sized_entries)
                    cond = ",".join(cond) or "default"
                    row(multi_row(n_entries, name), *bold_if(info.best, runtime, cond), multi_row(n_entries, size), *bold_if(info.best, f"{info.mean:0.2f}", f"{info.stddev:0.2f}", f"{info.ratio:0.2f}"))
                    end_row()
                
                    for name, size, runtime, cond, info in sized_entries:
                        cond = ",".join(cond) or "default"
                        row("", *bold_if(info.best, runtime, cond), "", *bold_if(info.best, f"{info.mean:0.2f}", f"{info.stddev:0.2f}", f"{info.ratio:0.2f}"))
                        end_row()
            
            bottomrule()


    def print_chart(self):
        
        entries = [(*k, v) for (k, v) in self.entries.items()]
        entries.sort(key=itemgetter(2, 3))

        with env("tikzpicture"):
            
            inputs = []
            for (benchname, input, _, _, _) in entries:
                if not input in inputs:
                    inputs.append(input)
            inputs_str = ",".join(map(str, inputs))

            if len(inputs) == 1:
                ticklabels = benchname
            else:
                ticklabels = inputs_str

            with env("axis", rf"""[
                ybar,
                ymin=0.0,
                ylabel=Time (s),
                xtick=data,
                scaled ticks=false,
                symbolic x coords={{{inputs_str}}},
                width=0.3\textwidth,
                height=0.35\textwidth,
                xticklabels={{{ticklabels}}},
                ymajorgrids,
                nodes near coords,
                legend pos=outer north east,
                every node near coord/.append style={{
                    rotate=90, anchor=west, /pgf/number format/fixed
                }},
                enlarge y limits={{upper,value=0.4}},
                enlarge x limits=0.5,
            ]"""):
    
                best_times = defaultdict(OrderedDict)
                best_info = defaultdict(OrderedDict)

                for (_, input, runtime, cond, info) in entries:
                    if info.mean < best_times[runtime].get(input, float("inf")):
                        best_times[runtime][input] = info.mean
                        best_info[runtime][input] = info
                    

                runtimes = []
                for runtime, input_info in best_info.items():
                    runtimes.append(runtime)

                    infos = [f"({input}, {info.mean/1000:0.2f})" for input, info in input_info.items() ]
                    add_bar_coordinates(default_colors[runtime], infos)

                add_legend(runtimes)
                





    def print_graph(self):

        entries = [(*k, v) for (k, v) in self.entries.items()]
        entries.sort(key=itemgetter(2, 3))

        with env("tikzpicture"):
            with env("axis", r"""[
                xmode=log,
                ymode=log,
                xlabel=Input size,
                ylabel=Time (secs),
                legend pos=outer north east,
                width=0.5\textwidth,
                height=0.5\textwidth,
            ]"""):

                labels = []
                grouped = [
                    ("-".join((runtime, *cond)), list(entries)) 
                    for ((runtime, cond), entries) in groupby(entries, itemgetter(2, 3))
                ]

                for (label, cond_entries) in grouped:
                    infos = list(map(itemgetter(-1), cond_entries))
                    labels.append(label)

                    coordinates = [(int(info.input), info.mean / 1000) for info in infos]
                    add_plot_coordinates(default_colors[label], coordinates)

                # for (label, cond_entries) in grouped:
                #     infos = list(map(itemgetter(-1), cond_entries))
                #     label_hi = label+"hi"
                #     label_lo = label+"lo"

                #     coordinates_hi = [(int(info.input), (info.mean + info.stddev) / 1000) for info in infos]
                #     coordinates_lo = [(int(info.input), (info.mean - info.stddev) / 1000) for info in infos]
                    
                #     add_plot_coordinates(label_hi, color_of[label], coordinates_hi)
                #     add_plot_coordinates(label_lo, color_of[label], coordinates_lo)

                #     fill_between(label+"hi", label+"lo", color_of[label])


                add_legend(labels)


            

def bench_results(d):
    benches = []

    for bench in d["results"]:
        bench = dotdict(bench)
        
        cmd = bench.command.split("<")
        exe, runtime, *_ = *cmd[0].strip("./ ").split()[::-1], "us"
        
        inp = os.path.basename(cmd[1].strip()).split(".")
        exe = exe.split(".")

        bench.name    = inp[0].replace("_", "-")
        bench.input   = "n/a" if len(inp) == 2 else inp[1]
        bench.cond    = tuple(exe[1:-1])
        bench.runtime = runtime.capitalize()
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

    runtimes = ["python3", "pypy3", "elixir", "us"]

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
    results = ResultsManager()
    for in_filename in sys.argv[2:]:
        with open(in_filename, "r") as f:
            results.ingest(json.load(f))
    if sys.argv[1] == "table":
        results.print_table()
    elif sys.argv[1] == "line-graph":
        results.print_graph()
    elif sys.argv[1] == "bar-chart":
        results.print_chart()




