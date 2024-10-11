using BenchmarkTools
using CairoMakie

x = [1, 20000, 40000, 60000, 80000, 100000]

# To get these, copy the output from pokemon.rkt to a file
# Then run the parse_swindle.py script
swindle_results = [
    (0.0, 0.0),
    (11.0, 0.0),
    (23.0, 0.0),
    (33.0, 0.0),
    (46.0, 0.0),
    (59.0, 0.0),
]

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
    plot_results!(ax1, swindle_results, "Swindle")

    f[1, 2] = Legend(f, ax1, framevisible=false)

    f
end

f = plot_figure()
save("swindle_plot.pdf", f)
