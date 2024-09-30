using BenchmarkTools
using CairoMakie
using ProfileView

include("lib.jl")
include("lib2.jl")

function attack_n_times(N, charmander, water_gun, attack_mult)
    acc = 0.0
    for _ in 1:N
        acc += attack_mult(water_gun, charmander)
    end

    acc
end

# setup the benchark suite
suite = BenchmarkGroup()
suite["liberalitas"] = BenchmarkGroup()
suite["liberalitas2"] = BenchmarkGroup()

# setup the function args
lib_charmander = Lib.make(Lib.Charmander, health=100)
lib_water_gun = Lib.make(Lib.WaterGun)
lib2_charmander = Lib2.make(Lib2.Charmander, health=100)
lib2_water_gun = Lib2.make(Lib2.WaterGun)

# ensure everything is compiled
attack_n_times(1, lib_charmander, lib_water_gun, Lib.attack_mult)
attack_n_times(1, lib2_charmander, lib2_water_gun, Lib2.attack_mult)

# profiling, uncomment and execute the following lines to profile
# @profview attack_n_times(1, lib_charmander, lib_water_gun, Lib.attack_mult)
# @profview attack_n_times(1, lib2_charmander, lib2_water_gun, Lib2.attack_mult)

for n in 0:10
    iters = n == 0 ? 1 : n * 10000
    suite["liberalitas"][iters] = @benchmarkable attack_n_times($iters, $lib_charmander, $lib_water_gun, $Lib.attack_mult)
    suite["liberalitas2"][iters] = @benchmarkable attack_n_times($iters, $lib2_charmander, $lib2_water_gun, $Lib2.attack_mult)
end

# run the benchmarks
results = run(suite, verbose=true)

# plotting
function plot_results!(ax, results, label)
    mean_times = sort(collect(time(mean(results))), by=first)
    stddev = map(last, sort(collect(time(std(results))), by=first)) / 1e6
    x = map(first, mean_times)
    y = map(last, mean_times) / 1e6

    lines!(ax, x, y; label)
    errorbars!(ax, x, y, stddev, stddev, whiskerwidth=10)
end

function plot_figure()
    f = Figure(size=(800, 450))
    limits = (0, nothing, 0, nothing)

    ax1 = Axis(f[1, 1], xlabel="Iteration Count", ylabel="Execution Time (ms)"; limits)

    plot_results!(ax1, results["liberalitas"], "Liberalitas")
    plot_results!(ax1, results["liberalitas2"], "Liberalitas (Optimized)")

    f[1, 2] = Legend(f, ax1, framevisible=false)

    f
end

f = plot_figure()
save("plot.pdf", f)
