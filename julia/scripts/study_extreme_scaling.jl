using AgenticAxtell
using Base.Threads
using Random

parse_list(argument::String) = parse.(Int, split(argument, ','))

populations = length(ARGS) >= 1 ? sort(unique(parse_list(ARGS[1]))) : [100, 250, 500, 1000]
periods = length(ARGS) >= 2 ? parse(Int, ARGS[2]) : 40
burn_in = length(ARGS) >= 3 ? parse(Int, ARGS[3]) : periods ÷ 4
seeds = length(ARGS) >= 4 ? parse_list(ARGS[4]) : collect(101:105)

length(populations) >= 2 || error("at least two populations are required")
all(>(2), populations) || error("populations must all exceed two")
0 <= burn_in < periods || error("burn-in must be in 0:(periods-1)")

median_value(values) = begin
    ordered = sort(collect(values))
    middle = length(ordered) ÷ 2
    isodd(length(ordered)) ? ordered[middle + 1] :
        (ordered[middle] + ordered[middle + 1]) / 2
end

truncated_second_moment(values, cutoff) =
    sum(value -> min(value, cutoff)^2, values) / length(values)

function log_slope(x, y)
    lx, ly = log.(Float64.(x)), log.(Float64.(y))
    xmean, ymean = sum(lx) / length(lx), sum(ly) / length(ly)
    sum((lx[index] - xmean) * (ly[index] - ymean) for index in eachindex(lx)) /
        sum((value - xmean)^2 for value in lx)
end

jobs = [(population, seed) for population in populations for seed in seeds]
rows = Vector{NamedTuple}(undef, length(jobs))
@threads for index in eachindex(jobs)
    population, seed = jobs[index]
    params = ModelParams(n_max=population, neighbors_per_agent=2)
    result = simulate(seed, params; periods, record_draws=false)
    sampled = result.period_states[(burn_in + 1):end]
    sizes = collect(Iterators.flatten(values(firm_sizes(state)) for state in sampled))
    mean_normalized_gini =
        sum(normalized_gini(collect(values(firm_sizes(state)))) for state in sampled) /
        length(sampled)
    terminal = collect(values(firm_sizes(last(sampled))))
    median_size = median_value(sizes)
    terminal_maximum = maximum(terminal)
    cutoff_sqrt = max(1, round(Int, sqrt(population)))
    cutoff_three_quarters = max(1, round(Int, population^0.75))
    cutoff_tenth = max(1, round(Int, population / 10))
    rows[index] = (
        population=population,
        seed=seed,
        observations=length(sizes),
        median_size=median_size,
        terminal_maximum=terminal_maximum,
        maximum_over_median=terminal_maximum / median_size,
        mean_normalized_gini=mean_normalized_gini,
        cutoff_sqrt=cutoff_sqrt,
        moment_sqrt=truncated_second_moment(sizes, cutoff_sqrt),
        cutoff_three_quarters=cutoff_three_quarters,
        moment_three_quarters=truncated_second_moment(sizes, cutoff_three_quarters),
        cutoff_tenth=cutoff_tenth,
        moment_tenth=truncated_second_moment(sizes, cutoff_tenth),
    )
end

println("population,seed,observations,median_size,terminal_maximum,maximum_over_median," *
        "mean_normalized_gini," *
        "cutoff_sqrt,moment_sqrt,cutoff_three_quarters,moment_three_quarters," *
        "cutoff_tenth,moment_tenth")
for row in rows
    println(join(row, ','))
end

println("seed,maximum_exponent,ratio_exponent,moment_sqrt_exponent," *
        "moment_three_quarters_exponent,moment_tenth_exponent")
exponents = NamedTuple[]
for seed in seeds
    seed_rows = sort(filter(row -> row.seed == seed, rows); by=row -> row.population)
    entry = (
        seed=seed,
        maximum_exponent=log_slope(populations, getproperty.(seed_rows, :terminal_maximum)),
        ratio_exponent=log_slope(populations, getproperty.(seed_rows, :maximum_over_median)),
        moment_sqrt_exponent=log_slope(populations, getproperty.(seed_rows, :moment_sqrt)),
        moment_three_quarters_exponent=
            log_slope(populations, getproperty.(seed_rows, :moment_three_quarters)),
        moment_tenth_exponent=log_slope(populations, getproperty.(seed_rows, :moment_tenth)),
    )
    push!(exponents, entry)
    println(join(entry, ','))
end

println("summary,median,bootstrap_low,bootstrap_high")
rng = Xoshiro(20260909)
for field in (:maximum_exponent, :ratio_exponent, :moment_sqrt_exponent,
              :moment_three_quarters_exponent, :moment_tenth_exponent)
    values = getproperty.(exponents, field)
    bootstrap = sort([median_value(rand(rng, values, length(values))) for _ in 1:10_000])
    println(join((field, median_value(values), bootstrap[250], bootstrap[9750]), ','))
end
