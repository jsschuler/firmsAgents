using AgenticAxtell
using Base.Threads

periods = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 40
burn_in = length(ARGS) >= 2 ? parse(Int, ARGS[2]) : periods ÷ 4

function parse_seeds(argument::String)
    if occursin(':', argument)
        bounds = parse.(Int, split(argument, ':'))
        length(bounds) == 2 || error("seed range must be START:STOP")
        UInt64.(bounds[1]:bounds[2])
    else
        UInt64.(parse.(Int, split(argument, ',')))
    end
end

seeds = length(ARGS) >= 3 ? parse_seeds(ARGS[3]) : UInt64.(101:120)
params = axtell_base_case()
slots = Vector{Union{Nothing,ValidationSummary}}(nothing, length(seeds))

@threads for index in eachindex(seeds)
    config = ValidationConfig(seeds=UInt64[seeds[index]], periods=periods, burn_in=burn_in)
    slots[index] = validate_baseline(params; config)
end

summaries = ValidationSummary[summary::ValidationSummary for summary in slots]

println("threads=", nthreads())
println("periods=", periods)
println("burn_in=", burn_in)
println("seed,ending_firms,max_size,rank_slope,rank_r2,growth_excess_kurtosis,laplace_ks,dispersion_slope,dispersion_r2")
for (seed, summary) in zip(seeds, summaries)
    println(join((
        seed, only(summary.ending_firm_counts), only(summary.ending_max_sizes),
        summary.rank_size_slope, summary.rank_size_r_squared,
        summary.growth_excess_kurtosis, summary.growth_laplace_ks,
        summary.size_dispersion_slope, summary.size_dispersion_r_squared,
    ), ','))
end

rank = [summary.rank_size_slope for summary in summaries if isfinite(summary.rank_size_slope)]
kurtosis = [summary.growth_excess_kurtosis for summary in summaries if isfinite(summary.growth_excess_kurtosis)]
dispersion = [summary.size_dispersion_slope for summary in summaries if isfinite(summary.size_dispersion_slope)]

median_value(values) = begin
    ordered = sort(values)
    n = length(ordered)
    isodd(n) ? ordered[n ÷ 2 + 1] : (ordered[n ÷ 2] + ordered[n ÷ 2 + 1]) / 2
end

println("rank_negative=", count(<(0), rank), "/", length(rank))
println("rank_median=", median_value(rank))
println("rank_range=", extrema(rank))
println("growth_excess_kurtosis_positive=", count(>(0), kurtosis), "/", length(kurtosis))
println("growth_excess_kurtosis_median=", median_value(kurtosis))
println("growth_excess_kurtosis_range=", extrema(kurtosis))
println("dispersion_negative=", count(<(0), dispersion), "/", length(dispersion))
println("dispersion_median=", median_value(dispersion))
println("dispersion_range=", extrema(dispersion))
