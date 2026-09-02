struct AgentId
    value::Int
    AgentId(value::Int) = value > 0 ? new(value) : throw(ArgumentError("agent ID must be positive"))
end

struct FirmId
    value::Int
    FirmId(value::Int) = value > 0 ? new(value) : throw(ArgumentError("firm ID must be positive"))
end

Base.:(==)(left::AgentId, right::AgentId) = left.value == right.value
Base.:(==)(left::FirmId, right::FirmId) = left.value == right.value
Base.hash(id::AgentId, seed::UInt) = hash(id.value, seed)
Base.hash(id::FirmId, seed::UInt) = hash(id.value, seed)

"""Baseline fields plus inert extension state for an active agent."""
struct AgentState
    id::AgentId
    theta::Float64
    effort::Float64
    firm_id::FirmId
    neighbors::Vector{AgentId}
    compute::Float64
    parent::Union{Nothing,AgentId}
    specialization::Int
end

"""A firm identity. Membership is represented canonically by `AgentState.firm_id`."""
struct FirmState
    id::FirmId
end

"""Finite global state with active agents and firms."""
struct ModelState
    agents::Vector{AgentState}
    firms::Vector{FirmState}
    next_agent_id::Int
    next_firm_id::Int
end

Base.:(==)(left::AgentState, right::AgentState) =
    left.id == right.id && left.theta == right.theta && left.effort == right.effort &&
    left.firm_id == right.firm_id && left.neighbors == right.neighbors &&
    left.compute == right.compute &&
    left.parent == right.parent && left.specialization == right.specialization
Base.:(==)(left::FirmState, right::FirmState) = left.id == right.id
Base.:(==)(left::ModelState, right::ModelState) =
    left.agents == right.agents && left.firms == right.firms &&
    left.next_agent_id == right.next_agent_id && left.next_firm_id == right.next_firm_id

"""Check the explicit milestone state invariants."""
function valid(state::ModelState, params::ModelParams)
    valid(params) || return false
    length(state.agents) <= params.n_max || return false
    agent_ids = getfield.(state.agents, :id)
    firm_ids = getfield.(state.firms, :id)
    length(unique(agent_ids)) == length(agent_ids) || return false
    length(unique(firm_ids)) == length(firm_ids) || return false
    all(agent -> agent.firm_id in firm_ids, state.agents) || return false
    all(firm -> any(agent -> agent.firm_id == firm.id, state.agents), state.firms) || return false
    all(agent -> isfinite(agent.theta) && 0.0 <= agent.theta <= 1.0, state.agents) || return false
    all(agent -> isfinite(agent.effort) && 0.0 <= agent.effort <= 1.0, state.agents) || return false
    all(agent -> agent.compute >= 0, state.agents) || return false
    all(agent -> length(agent.neighbors) == params.neighbors_per_agent, state.agents) || return false
    all(agent -> length(unique(agent.neighbors)) == length(agent.neighbors), state.agents) || return false
    all(agent -> all(neighbor -> neighbor in agent_ids && neighbor != agent.id, agent.neighbors), state.agents) || return false
    all(agent -> agent.parent === nothing || agent.parent in agent_ids, state.agents) || return false
    isempty(agent_ids) || state.next_agent_id > maximum(id.value for id in agent_ids) || return false
    isempty(firm_ids) || state.next_firm_id > maximum(id.value for id in firm_ids) || return false
    state.next_agent_id > 0 && state.next_firm_id > 0
end

firm_ids(state::ModelState) = getfield.(state.firms, :id)
firm_members(state::ModelState, firm_id::FirmId) = filter(agent -> agent.firm_id == firm_id, state.agents)
firm_effort(state::ModelState, firm_id::FirmId) = sum((agent.effort for agent in firm_members(state, firm_id)); init=0.0)
