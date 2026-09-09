using AgenticAxtell
using Base.Threads

parse_list(argument::String) = parse.(Int, split(argument, ','))

populations = length(ARGS) >= 1 ? sort(unique(parse_list(ARGS[1]))) : [100, 250, 500, 1000]
periods = length(ARGS) >= 2 ? parse(Int, ARGS[2]) : 40
burn_in = length(ARGS) >= 3 ? parse(Int, ARGS[3]) : periods ÷ 4
replications = length(ARGS) >= 4 ? parse(Int, ARGS[4]) : 30
first_seed = length(ARGS) >= 5 ? parse(Int, ARGS[5]) : 1001

all(>(2), populations) || error("populations must all exceed two")
0 <= burn_in < periods || error("burn-in must be in 0:(periods-1)")
replications >= 2 || error("at least two replications are required")

jobs = [(population, replication, first_seed + replication - 1)
        for population in populations for replication in 1:replications]
rows = Vector{NamedTuple}(undef, length(jobs))

@threads for index in eachindex(jobs)
    population, replication, seed = jobs[index]
    params = ModelParams(n_max=population, neighbors_per_agent=2)
    result = simulate(seed, params; periods, record_draws=false)
    sampled = result.period_states[(burn_in + 1):end]
    period_means = [population / length(state.firms) for state in sampled]
    rows[index] = (
        population=population,
        replication=replication,
        seed=seed,
        mean_firm_size=sum(period_means) / length(period_means),
    )
end

sample_standard_deviation(values) = begin
    mean_value = sum(values) / length(values)
    sqrt(sum((value - mean_value)^2 for value in values) / (length(values) - 1))
end

function convergence_rows(values)
    [begin
        prefix = values[1:n]
        estimate = sum(prefix) / n
        standard_error = sample_standard_deviation(prefix) / sqrt(n)
        half_width = 1.96 * standard_error
        (; replications=n, estimate, standard_error, half_width,
           relative_half_width=half_width / estimate)
    end for n in 2:length(values)]
end

function persistent_threshold(convergence, threshold)
    position = findfirst(eachindex(convergence)) do index
        all(row.relative_half_width <= threshold for row in convergence[index:end])
    end
    isnothing(position) ? "not_reached" : string(convergence[position].replications)
end

println("population,replication,seed,mean_firm_size")
for row in rows
    println(join(row, ','))
end

println("population,replications,estimate,standard_error,half_width,relative_half_width")
for population in populations
    values = [row.mean_firm_size for row in rows if row.population == population]
    for row in convergence_rows(values)
        println(join((population, row...), ','))
    end
end

println("population,final_estimate,final_relative_half_width,n_for_5pct,n_for_2pct,n_for_1pct")
for population in populations
    values = [row.mean_firm_size for row in rows if row.population == population]
    convergence = convergence_rows(values)
    final = last(convergence)
    println(join((population, final.estimate, final.relative_half_width,
                  persistent_threshold(convergence, 0.05),
                  persistent_threshold(convergence, 0.02),
                  persistent_threshold(convergence, 0.01)), ','))
end
