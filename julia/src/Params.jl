"""Parameters for the continuous-effort semantic Axtell baseline."""
Base.@kwdef struct ModelParams
    n_max::Int
    a::Float64 = 1.0
    b::Float64 = 1.0
    beta::Float64 = 2.0
    neighbors_per_agent::Int = 2
    activations_per_period::Int = n_max
    initial_effort::Float64 = 0.5
    optimization_tolerance::Float64 = 1e-10
    utility_tolerance::Float64 = 1e-12
end

"""Return the named Axtell computational base-case parameters."""
axtell_base_case() = ModelParams(n_max=1000)

valid(params::ModelParams) =
    params.n_max > 0 && params.a >= 0.0 && params.b >= 0.0 &&
    params.beta >= 1.0 && 0 <= params.neighbors_per_agent < params.n_max &&
    params.activations_per_period > 0 && 0.0 <= params.initial_effort <= 1.0 &&
    params.optimization_tolerance > 0.0 && params.utility_tolerance >= 0.0
