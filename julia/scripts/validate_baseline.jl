using AgenticAxtell

periods = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 100
burn_in = length(ARGS) >= 2 ? parse(Int, ARGS[2]) : periods ÷ 5
seeds = length(ARGS) >= 3 ? UInt64.(parse.(Int, split(ARGS[3], ','))) : UInt64[101, 202, 303]

config = ValidationConfig(seeds=seeds, periods=periods, burn_in=burn_in)
summary = validate_baseline(axtell_base_case(); config)

println("seeds=", join(summary.config.seeds, ','))
println("periods=", summary.config.periods)
println("burn_in=", summary.config.burn_in)
println("ending_firm_counts=", join(summary.ending_firm_counts, ','))
println("ending_max_sizes=", join(summary.ending_max_sizes, ','))
println("pooled_firm_size_observations=", length(summary.pooled_firm_sizes))
println("pooled_growth_observations=", length(summary.pooled_growth_rates))
println("completed_lifetime_observations=", length(summary.completed_lifetimes))
println("rank_size_slope=", summary.rank_size_slope)
println("rank_size_standard_error=", summary.rank_size_standard_error)
println("rank_size_r_squared=", summary.rank_size_r_squared)
println("rank_size_tail_count=", summary.rank_size_tail_count)
println("growth_laplace_scale=", summary.growth_laplace_scale)
println("growth_laplace_ks=", summary.growth_laplace_ks)
println("growth_excess_kurtosis=", summary.growth_excess_kurtosis)
println("size_dispersion_slope=", summary.size_dispersion_slope)
println("size_dispersion_standard_error=", summary.size_dispersion_standard_error)
println("size_dispersion_r_squared=", summary.size_dispersion_r_squared)
println("size_dispersion_group_count=", summary.size_dispersion_group_count)
println("aggregate_output_effort_slope=", summary.aggregate_output_effort_slope)
