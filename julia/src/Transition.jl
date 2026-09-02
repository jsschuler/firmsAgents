"""Apply the deterministic baseline and feature operators in canonical order."""
function step(state::ModelState, draw::Draw, config::ModelConfig, params::ModelParams)
    next = baseline_transition(state, draw, params)
    next = apply_extension(ComputeOperator(), Val(config.allow_compute), next, draw, params)
    next = apply_extension(SpawnOperator(), Val(config.allow_spawn), next, draw, params)
    next = apply_extension(TerminationOperator(), Val(config.allow_termination), next, draw, params)
    next = apply_extension(DelegationOperator(), Val(config.allow_delegation), next, draw, params)
    next = apply_extension(SpecializationOperator(), Val(config.allow_specialization), next, draw, params)
    next = apply_extension(HierarchyOperator(), Val(config.allow_hierarchy), next, draw, params)
    next = apply_extension(ComputeMarketOperator(), Val(config.allow_compute_market), next, draw, params)
    next = apply_extension(ComputeInheritanceOperator(), Val(config.allow_compute_inheritance), next, draw, params)
    apply_extension(AgentMutationOperator(), Val(config.allow_agent_mutation), next, draw, params)
end

"""Replay a supplied draw stream, returning the initial and all subsequent states."""
function trajectory(initial::ModelState, draws, config::ModelConfig, params::ModelParams)
    states = ModelState[initial]
    for draw in draws
        push!(states, step(states[end], draw, config, params))
    end
    states
end

