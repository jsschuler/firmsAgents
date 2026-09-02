Base.@kwdef struct ValidationConfig
    seeds::Vector{UInt64} = UInt64[101, 202, 303]
    periods::Int = 100
    burn_in::Int = 20
end

struct ValidationSummary
    config::ValidationConfig
    ending_firm_counts::Vector{Int}
    ending_max_sizes::Vector{Int}
    pooled_firm_sizes::Vector{Int}
    pooled_growth_rates::Vector{Float64}
    completed_lifetimes::Vector{Int}
    rank_size_slope::Float64
    rank_size_standard_error::Float64
    rank_size_r_squared::Float64
    rank_size_tail_count::Int
    growth_laplace_scale::Float64
    growth_laplace_ks::Float64
    growth_excess_kurtosis::Float64
    size_dispersion_slope::Float64
    size_dispersion_standard_error::Float64
    size_dispersion_r_squared::Float64
    size_dispersion_group_count::Int
    aggregate_output_effort_slope::Float64
end

function linear_fit(x::AbstractVector{<:Real}, y::AbstractVector{<:Real})
    length(x) == length(y) || throw(DimensionMismatch("x and y lengths differ"))
    length(x) >= 2 || return (; slope=NaN, intercept=NaN, standard_error=NaN, r_squared=NaN)
    xmean, ymean = sum(x) / length(x), sum(y) / length(y)
    ssx = sum((value - xmean)^2 for value in x)
    ssx == 0 && return (; slope=NaN, intercept=NaN, standard_error=NaN, r_squared=NaN)
    slope = sum((x[index] - xmean) * (y[index] - ymean) for index in eachindex(x)) / ssx
    intercept = ymean - slope * xmean
    residual_ss = sum((y[index] - intercept - slope * x[index])^2 for index in eachindex(x))
    total_ss = sum((value - ymean)^2 for value in y)
    standard_error = length(x) > 2 ? sqrt((residual_ss / (length(x) - 2)) / ssx) : NaN
    r_squared = total_ss == 0 ? NaN : 1.0 - residual_ss / total_ss
    (; slope, intercept, standard_error, r_squared)
end

linear_slope(x, y) = linear_fit(x, y).slope

function sample_median(values::AbstractVector{<:Real})
    isempty(values) && return NaN
    ordered = sort(collect(values))
    middle = length(ordered) ÷ 2
    isodd(length(ordered)) ? ordered[middle + 1] : (ordered[middle] + ordered[middle + 1]) / 2
end

function rank_size_fit(sizes::Vector{Int})
    tail = sort(filter(>=(2), sizes); rev=true)
    fit = linear_fit(log.(Float64.(tail)), log.((1:length(tail)) ./ length(tail)))
    (; fit..., count=length(tail))
end

function growth_shape(growth::Vector{Float64})
    isempty(growth) && return (NaN, NaN, NaN)
    center = sample_median(growth)
    scale = sum(abs(value - center) for value in growth) / length(growth)
    mean_value = sum(growth) / length(growth)
    second = sum((value - mean_value)^2 for value in growth) / length(growth)
    fourth = sum((value - mean_value)^4 for value in growth) / length(growth)
    excess = second == 0 ? NaN : fourth / second^2 - 3.0
    if scale == 0
        ks = NaN
    else
        ordered = sort(growth)
        n = length(ordered)
        laplace_cdf(value) = value < center ?
            0.5 * exp((value - center) / scale) :
            1.0 - 0.5 * exp(-(value - center) / scale)
        ks = maximum(max(abs(index / n - laplace_cdf(value)),
                         abs((index - 1) / n - laplace_cdf(value)))
                     for (index, value) in enumerate(ordered))
    end
    (scale, excess, ks)
end

function pooled_dispersion_fit(size_growth::Dict{Int,Vector{Float64}})
    pairs = sort([(size, sample_std(values)) for (size, values) in size_growth
                  if size >= 2 && length(values) >= 3 && sample_std(values) > 0])
    fit = linear_fit(log.(Float64[first(pair) for pair in pairs]),
                     log.(Float64[last(pair) for pair in pairs]))
    (; fit..., count=length(pairs))
end

function validate_baseline(params::ModelParams=axtell_base_case();
                           config::ValidationConfig=ValidationConfig())
    0 <= config.burn_in < config.periods ||
        throw(ArgumentError("burn_in must be in 0:(periods-1)"))
    sizes = Int[]
    growth = Float64[]
    lifetimes = Int[]
    ending_firms = Int[]
    ending_max = Int[]
    size_growth = Dict{Int,Vector{Float64}}()
    log_effort = Float64[]
    log_output = Float64[]

    for seed in config.seeds
        result = simulate(seed, params; periods=config.periods, record_draws=false)
        sampled = result.period_states[(config.burn_in + 1):end]
        append!(sizes, Iterators.flatten(values(firm_sizes(state)) for state in sampled))
        final_sizes = collect(values(firm_sizes(sampled[end])))
        push!(ending_firms, length(final_sizes))
        push!(ending_max, maximum(final_sizes))

        for index in 2:length(sampled)
            previous, current = sampled[index - 1], sampled[index]
            rates = firm_log_growth(previous, current, params)
            append!(growth, values(rates))
            previous_sizes = firm_sizes(previous)
            for (id, rate) in rates
                push!(get!(size_growth, previous_sizes[id], Float64[]), rate)
            end
        end
        append!(lifetimes, values(firm_lifetimes(result).completed))
        for state in sampled
            effort = sum(agent.effort for agent in state.agents; init=0.0)
            output = aggregate_output(state, params)
            if effort > 0 && output > 0
                push!(log_effort, log(effort))
                push!(log_output, log(output))
            end
        end
    end

    rank_fit = rank_size_fit(sizes)
    laplace_scale, excess_kurtosis, laplace_ks = growth_shape(growth)
    dispersion_fit = pooled_dispersion_fit(size_growth)
    ValidationSummary(
        config, ending_firms, ending_max, sizes, growth, lifetimes,
        rank_fit.slope, rank_fit.standard_error, rank_fit.r_squared, rank_fit.count,
        laplace_scale, laplace_ks, excess_kurtosis,
        dispersion_fit.slope, dispersion_fit.standard_error,
        dispersion_fit.r_squared, dispersion_fit.count,
        linear_slope(log_effort, log_output),
    )
end
