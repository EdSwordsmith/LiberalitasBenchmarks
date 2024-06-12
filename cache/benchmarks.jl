using BenchmarkTools
using CairoMakie

# Include the MOP prototype code
include("pokemon.jl")

function attack_n_times(N)
    attack = make(Fire)
    lotad = make(Lotad)

    for _ in 1:N
        attack_mult(attack, lotad)
    end
end

@class Person() (name, age)

function create_n_people(N)
    for _ in 1:N
        make(Person, name="Eduardo", age=22)
    end
end

function setup_suite()
    BenchmarkTools.DEFAULT_PARAMETERS.seconds = 12
    suite = BenchmarkGroup()
    suite["pokemon"] = BenchmarkGroup()
    suite["people"] = BenchmarkGroup()

    for n in 0:10
        iters = n == 0 ? 1 : n * 10000
        suite["pokemon"][iters] = @benchmarkable attack_n_times($iters)
        suite["people"][iters] = @benchmarkable create_n_people($iters)
    end

    suite
end

suite = setup_suite()

# Ensure everything is compiled
attack_n_times(1)
create_n_people(1)

cache_results = run(suite, verbose=true)

# Redefine function invocation so it doesn't use the cache
function (e::Entity)(args...; kwargs...)
    args_types = map(classof, args)
    methods = collect(values(e.methods))
    compatible_methods = filter(method -> compatible_args(args_types, method.types), methods)
    sort!(compatible_methods, lt=(x, y) -> args_more_specific(x, y, args_types), by=method -> method.types)

    apply_methods(compatible_methods, args, kwargs)
end

# Ensure everything is compiled
attack_n_times(1)
create_n_people(1)

nocache_results = run(suite, verbose=true)

# Plotting
function plot_results!(ax, results, label)
    mean_times = sort(collect(time(mean(results))), by=first)
    stddev = map(last, sort(collect(time(std(results))), by=first)) / 1e6
    x = map(first, mean_times)
    y = map(last, mean_times) / 1e6

    lines!(ax, x, y; label)
    errorbars!(ax, x, y, stddev, stddev, whiskerwidth=10)
end

function plot_figure()
    f = Figure(size=(1200, 450))
    limits = (0, nothing, 0, 2500)
    xticks = ((0:5) * 2e4)
    yticks = 0:500:2500

    ax1 = Axis(f[1, 1], xlabel="Iteration Count", ylabel="Execution Time (ms)"; limits, xticks, yticks)
    ax2 = Axis(f[1, 2], xlabel="Objects Created"; limits, xticks, yticks)

    plot_results!(ax1, nocache_results["pokemon"], "Without Cache")
    plot_results!(ax1, cache_results["pokemon"], "With Cache")

    plot_results!(ax2, nocache_results["people"], "Without Cache")
    plot_results!(ax2, cache_results["people"], "With Cache")

    f[1, 3] = Legend(f, ax2, framevisible=false)

    f
end

f = plot_figure()
save("plot.pdf", f)
