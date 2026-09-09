using AgenticAxtell
using Base.Threads

parse_list(argument::String) = parse.(Int, split(argument, ','))

population = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 1000
horizons = length(ARGS) >= 2 ? sort(unique(parse_list(ARGS[2]))) : [20, 40, 80]
seeds = length(ARGS) >= 3 ? parse_list(ARGS[3]) : collect(101:105)

population > 2 || error("population must exceed two")
all(>(1), horizons) || error("horizons must all exceed one period")
isempty(seeds) && error("at least one seed is required")

population_variance(values) = begin
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

rows_by_seed = Vector{Vector{NamedTuple}}(undef, length(seeds))
@threads for seed_index in eachindex(seeds)
    seed = seeds[seed_index]
    params = ModelParams(n_max=population, neighbors_per_agent=2)
    result = simulate(seed, params; periods=last(horizons), record_draws=false)
    rows = NamedTuple[]
    for horizon in horizons
        burn_in = horizon ÷ 2
        sampled_states = result.period_states[(burn_in + 1):horizon]
        sizes = collect(Iterators.flatten(values(firm_sizes(state)) for state in sampled_states))
        final_sizes = collect(values(firm_sizes(result.period_states[horizon])))
        second_moment = sum(abs2, sizes) / length(sizes)
        push!(rows, (
            population=population,
            horizon=horizon,
            burn_in=burn_in,
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
        ))
    end
    rows_by_seed[seed_index] = rows
end

println("population,horizon,burn_in,seed,observations,ending_firms,ending_maximum," *
        "maximum_share,mean_size,size_variance,size_second_moment," *
        "normalized_second_moment,rank_size_slope")
for horizon in horizons, rows in rows_by_seed
    println(join(only(filter(row -> row.horizon == horizon, rows)), ','))
end
