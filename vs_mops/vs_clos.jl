using BenchmarkTools
using CairoMakie

x = [1, 20000, 40000, 60000, 80000, 100000]

# To get these, copy the output from pokemon.lisp to a file
# Then run the parse_clos.sh script
clos_results = [
    (0.000005, 0.000071),
    (0.000252, 0.000434),
    (0.000507, 0.0005),
    (0.000758, 0.000431),
    (0.001015, 0.00017),
    (0.001249, 0.000432),
]
# convert to ms
toms(sec) = sec * 1000.0
clos_results_ms = map(v -> map(toms, v), clos_results)

# Get liberalitas results from running pokemon.jl
results = BenchmarkTools.load("liberalitas.json")[1]
mean_times = map(last, sort(collect(time(mean(results))), by=(v) -> parse(Int, first(v)))) / 1e6
stddev = map(last, sort(collect(time(std(results))), by=(v) -> parse(Int, first(v)))) / 1e6
liberalitas_results = collect(zip(mean_times, stddev))

# plotting
function plot_results!(ax, results, label)
    y = map(first, results)
    stddev = map(last, results)
    lines!(ax, x, y; label)
    errorbars!(ax, x, y, stddev, stddev, whiskerwidth=10)
end

function plot_figure()
    f = Figure(size=(800, 450))
    limits = (0, nothing, 0, nothing)

    ax1 = Axis(f[1, 1], xlabel="Iteration Count", ylabel="Execution Time (ms)"; limits)

    plot_results!(ax1, liberalitas_results, "Liberalitas")
    plot_results!(ax1, clos_results_ms, "CLOS")

    f[1, 2] = Legend(f, ax1, framevisible=false)

    f
end

f = plot_figure()
save("clos_plot.pdf", f)
