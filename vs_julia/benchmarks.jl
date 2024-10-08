using BenchmarkTools
using CairoMakie

include("vanilla.jl")
include("lib.jl")

function attack_n_times(N, charmander, water_gun, attack_mult)
    acc = 0.0
    for _ in 1:N
        acc += attack_mult(water_gun, charmander)
    end

    acc
end

# setup the benchark suite
suite = BenchmarkGroup()
suite["vanilla"] = BenchmarkGroup()
suite["liberalitas"] = BenchmarkGroup()

# setup the function args
vanilla_charmander = Vanilla.Charmander(100)
vanilla_water_gun = Vanilla.WaterGun()
lib_charmander = Lib.make(Lib.Charmander, health=100)
lib_water_gun = Lib.make(Lib.WaterGun)

# ensure everything is compiled
attack_n_times(1, vanilla_charmander, vanilla_water_gun, Vanilla.attack_mult)
attack_n_times(1, lib_charmander, lib_water_gun, Lib.attack_mult)

for n in 0:10
    iters = n == 0 ? 1 : n * 10000
    suite["vanilla"][iters] = @benchmarkable attack_n_times($iters, $vanilla_charmander, $vanilla_water_gun, $Vanilla.attack_mult)
    suite["liberalitas"][iters] = @benchmarkable attack_n_times($iters, $lib_charmander, $lib_water_gun, $Lib.attack_mult)
end

# run the benchmarks
noprint_results = run(suite, verbose=true)

# redefine attack_n_times to simulate more computation
function attack_n_times(N, charmander, water_gun, attack_mult)
    acc = 0.0
    for _ in 1:N
        acc += attack_mult(water_gun, charmander)
        print("Squirtle used water gun.")
    end

    acc
end

# ensure everything is compiled
attack_n_times(1, vanilla_charmander, vanilla_water_gun, Vanilla.attack_mult)
attack_n_times(1, lib_charmander, lib_water_gun, Lib.attack_mult)

print_results = run(suite, verbose=true, seconds=24)

# plotting
function plot_results!(ax, results, label)
    mean_times = sort(collect(time(mean(results))), by=first)
    stddev = map(last, sort(collect(time(std(results))), by=first)) / 1e6
    x = map(first, mean_times)
    y = map(last, mean_times) / 1e6

    lines!(ax, x, y; label)
    errorbars!(ax, x, y, stddev, stddev, whiskerwidth=10)
end

function plot_figure(results)
    f = Figure(size=(1200, 450))
    limits = (0, nothing, 0, nothing)

    ax1 = Axis(f[1, 1], xlabel="Iteration Count", ylabel="Execution Time (ms)"; limits)

    plot_results!(ax1, results["vanilla"], "Native Julia")
    plot_results!(ax1, results["liberalitas"], "Liberalitas")

    f[1, 2] = Legend(f, ax1, framevisible=false)

    f
end

f1 = plot_figure(noprint_results)
save("noprint_plot.pdf", f1)

f2 = plot_figure(print_results)
save("print_plot.pdf", f2)
