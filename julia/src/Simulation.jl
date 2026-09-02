struct SimulationMetadata
    seed::UInt64
    periods::Int
    activations_per_period::Int
    population::Int
    a::Float64
    b::Float64
    beta::Float64
    neighbors_per_agent::Int
    initial_effort::Float64
    optimization_tolerance::Float64
    utility_tolerance::Float64
    config::ModelConfig
end

struct SimulationResult
    metadata::SimulationMetadata
    initial_state::ModelState
    period_states::Vector{ModelState}
    draws::Vector{Draw}
end

"""Run event-level asynchronous dynamics and retain reporting-period states."""
function simulate(seed::Integer, params::ModelParams=axtell_base_case();
                  periods::Int, config::ModelConfig=baseline_config(),
                  record_draws::Bool=true)
    periods >= 0 || throw(ArgumentError("periods must be nonnegative"))
    seed >= 0 || throw(ArgumentError("seed must be nonnegative"))
    rng = Xoshiro(UInt64(seed))
    initial = initialize(rng, params)
    state = initial
    period_states = ModelState[]
    draws = Draw[]
    for _ in 1:periods
        for _ in 1:params.activations_per_period
            draw = sample_draw(rng, state, config, params)
            record_draws && push!(draws, draw)
            state = step(state, draw, config, params)
        end
        push!(period_states, state)
    end
    metadata = SimulationMetadata(
        UInt64(seed), periods, params.activations_per_period, params.n_max,
        params.a, params.b, params.beta, params.neighbors_per_agent,
        params.initial_effort, params.optimization_tolerance,
        params.utility_tolerance, config,
    )
    SimulationResult(metadata, initial, period_states, draws)
end
