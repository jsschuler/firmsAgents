using AgenticAxtell

population = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 100
periods = length(ARGS) >= 2 ? parse(Int, ARGS[2]) : 5000
seed = length(ARGS) >= 3 ? parse(Int, ARGS[3]) : 20260909
window = length(ARGS) >= 4 ? parse(Int, ARGS[4]) : 100

population > 2 || error("population must exceed two")
periods > 0 || error("periods must be positive")
window > 0 || error("window must be positive")

median_value(values) = begin
    ordered = sort(collect(values))
    middle = length(ordered) ÷ 2
    isodd(length(ordered)) ? ordered[middle + 1] :
        (ordered[middle] + ordered[middle + 1]) / 2
end

function snapshot_statistics(state)
    sizes = collect(values(firm_sizes(state)))
    mean_size = sum(sizes) / length(sizes)
    median_size = median_value(sizes)
    second_moment = sum(abs2, sizes) / length(sizes)
    variance = second_moment - mean_size^2
    maximum_size = maximum(sizes)
    (
        active_firms=length(sizes),
        mean_size=mean_size,
        median_size=median_size,
        variance=variance,
        second_moment=second_moment,
        normalized_gini=normalized_gini(sizes),
        maximum_size=maximum_size,
        maximum_over_median=maximum_size / median_size,
    )
end

function average_statistics(statistics)
    fields = propertynames(first(statistics))
    NamedTuple{fields}(Tuple(sum(getproperty(row, field) for row in statistics) /
                             length(statistics) for field in fields))
end

default_checkpoints = [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000]
checkpoints = sort(unique([checkpoint for checkpoint in default_checkpoints if checkpoint <= periods]))
last(checkpoints) == periods || push!(checkpoints, periods)

params = ModelParams(n_max=population, neighbors_per_agent=2)
result = simulate(seed, params; periods, record_draws=false)
statistics = snapshot_statistics.(result.period_states)

println("population,seed,period,statistic,window_start,active_firms,mean_size,median_size," *
        "variance,second_moment,normalized_gini,maximum_size,maximum_over_median")
for checkpoint in checkpoints
    start = max(1, checkpoint - window + 1)
    instantaneous = statistics[checkpoint]
    trailing = average_statistics(statistics[start:checkpoint])
    println(join((population, seed, checkpoint, "instantaneous", checkpoint,
                  instantaneous...), ','))
    println(join((population, seed, checkpoint, "trailing", start, trailing...), ','))
end
