using AgenticAxtell
using Base.Threads

parse_list(argument::String) = parse.(Int, split(argument, ','))

populations = length(ARGS) >= 1 ? parse_list(ARGS[1]) : [100, 250, 500, 1000]
periods = length(ARGS) >= 2 ? parse(Int, ARGS[2]) : 40
burn_in = length(ARGS) >= 3 ? parse(Int, ARGS[3]) : periods ÷ 4
seeds = length(ARGS) >= 4 ? parse_list(ARGS[4]) : collect(101:105)

all(>(2), populations) || error("populations must all exceed two")
0 <= burn_in < periods || error("burn-in must be in 0:(periods-1)")
isempty(seeds) && error("at least one seed is required")

function population_variance(values)
    mean_value = sum(values) / length(values)
    sum((value - mean_value)^2 for value in values) / length(values)
end

function rank_size_slope(values)
    sizes = sort(filter(>=(2), values); rev=true)
    length(sizes) >= 2 || return NaN
    x = log.(Float64.(sizes))
    y = log.((1:length(sizes)) ./ length(sizes))
    xmean, ymean = sum(x) / length(x), sum(y) / length(y)
    denominator = sum((value - xmean)^2 for value in x)
    denominator == 0 && return NaN
    sum((x[index] - xmean) * (y[index] - ymean) for index in eachindex(x)) /
        denominator
end

jobs = [(population, seed) for population in populations for seed in seeds]
rows = Vector{NamedTuple}(undef, length(jobs))

@threads for index in eachindex(jobs)
    population, seed = jobs[index]
    params = ModelParams(n_max=population, neighbors_per_agent=2)
    result = simulate(seed, params; periods, record_draws=false)
    sampled_states = result.period_states[(burn_in + 1):end]
    sizes = collect(Iterators.flatten(values(firm_sizes(state)) for state in sampled_states))
    final_sizes = collect(values(firm_sizes(last(sampled_states))))
    second_moment = sum(abs2, sizes) / length(sizes)
    rows[index] = (
        population=population,
        seed=seed,
        observations=length(sizes),
        ending_firms=length(final_sizes),
        ending_maximum=maximum(final_sizes),
        maximum_share=maximum(final_sizes) / population,
        mean_size=sum(sizes) / length(sizes),
        size_variance=population_variance(sizes),
        size_second_moment=second_moment,
        normalized_second_moment=second_moment / population^2,
        rank_size_slope=rank_size_slope(sizes),
    )
end

println("population,seed,observations,ending_firms,ending_maximum,maximum_share," *
        "mean_size,size_variance,size_second_moment,normalized_second_moment,rank_size_slope")
for row in rows
    println(join(row, ','))
end
