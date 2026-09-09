using AgenticAxtell
using Base.Threads
using Random

parse_list(argument::String) = parse.(Int, split(argument, ','))

population = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 1000
periods = length(ARGS) >= 2 ? parse(Int, ARGS[2]) : 40
burn_in = length(ARGS) >= 3 ? parse(Int, ARGS[3]) : periods ÷ 4
seeds = length(ARGS) >= 4 ? parse_list(ARGS[4]) : collect(101:110)
tail_fractions = (0.05, 0.10, 0.20)
cutoffs = (5, 10, 20, 40, 80)

population > 2 || error("population must exceed two")
0 <= burn_in < periods || error("burn-in must be in 0:(periods-1)")
isempty(seeds) && error("at least one seed is required")

function hill_index(values, fraction)
    positive = sort(Float64.(filter(>(0), values)); rev=true)
    length(positive) >= 3 || return NaN
    k = clamp(round(Int, fraction * length(positive)), 2, length(positive) - 1)
    threshold = positive[k + 1]
    denominator = sum(log(positive[index] / threshold) for index in 1:k)
    denominator > 0 ? k / denominator : Inf
end

truncated_second_moment(values, cutoff) =
    sum(value -> min(value, cutoff)^2, values) / length(values)

rows = Vector{NamedTuple}(undef, length(seeds))
@threads for index in eachindex(seeds)
    seed = seeds[index]
    params = ModelParams(n_max=population, neighbors_per_agent=2)
    result = simulate(seed, params; periods, record_draws=false)
    sampled = result.period_states[(burn_in + 1):end]
    sizes = collect(Iterators.flatten(values(firm_sizes(state)) for state in sampled))
    rows[index] = (
        seed=seed,
        observations=length(sizes),
        maximum=maximum(sizes),
        hill_05=hill_index(sizes, tail_fractions[1]),
        hill_10=hill_index(sizes, tail_fractions[2]),
        hill_20=hill_index(sizes, tail_fractions[3]),
        tm_5=truncated_second_moment(sizes, cutoffs[1]),
        tm_10=truncated_second_moment(sizes, cutoffs[2]),
        tm_20=truncated_second_moment(sizes, cutoffs[3]),
        tm_40=truncated_second_moment(sizes, cutoffs[4]),
        tm_80=truncated_second_moment(sizes, cutoffs[5]),
    )
end

median_value(values) = begin
    ordered = sort(collect(values))
    middle = length(ordered) ÷ 2
    isodd(length(ordered)) ? ordered[middle + 1] :
        (ordered[middle] + ordered[middle + 1]) / 2
end

function seed_bootstrap_interval(values; replicates=10_000, rng=Xoshiro(20260909))
    estimates = [median_value(rand(rng, values, length(values))) for _ in 1:replicates]
    sort!(estimates)
    (estimates[round(Int, 0.025 * replicates)],
     estimates[round(Int, 0.975 * replicates)])
end

println("seed,observations,maximum,hill_05,hill_10,hill_20,tm_5,tm_10,tm_20,tm_40,tm_80")
for row in rows
    println(join(row, ','))
end
println("summary,median,bootstrap_low,bootstrap_high")
for field in (:hill_05, :hill_10, :hill_20, :tm_5, :tm_10, :tm_20, :tm_40, :tm_80)
    values = getproperty.(rows, field)
    low, high = seed_bootstrap_interval(values)
    println(join((field, median_value(values), low, high), ','))
end
