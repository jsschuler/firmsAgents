"""Feature switches for the baseline and agentic transition layers."""
Base.@kwdef struct ModelConfig
    faithful_axtell::Bool = true
    allow_compute::Bool = false
    allow_spawn::Bool = false
    allow_termination::Bool = false
    allow_delegation::Bool = false
    allow_specialization::Bool = false
    allow_hierarchy::Bool = false
    allow_compute_market::Bool = false
    allow_compute_inheritance::Bool = false
    allow_agent_mutation::Bool = false
end

"""Return the exact Axtell-nesting feature configuration."""
baseline_config() = ModelConfig()

"""Return a configuration with every extension feature enabled."""
all_extensions_enabled() = ModelConfig(
    allow_compute=true, allow_spawn=true, allow_termination=true,
    allow_delegation=true, allow_specialization=true, allow_hierarchy=true,
    allow_compute_market=true, allow_compute_inheritance=true,
    allow_agent_mutation=true,
)
