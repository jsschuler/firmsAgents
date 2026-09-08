abstract type AbstractEffortDomain end

"""The faithful continuous-effort domain."""
struct ContinuousEffort <: AbstractEffortDomain end

"""A finite grid with `K` equal subintervals and `K + 1` effort levels."""
struct EffortGrid{K} <: AbstractEffortDomain end

function EffortGrid(steps::Integer)
    steps > 0 || throw(ArgumentError("effort-grid steps must be positive"))
    EffortGrid{Int(steps)}()
end

"""An index in `0:K` belonging to an `EffortGrid{K}`."""
struct EffortLevel{K}
    index::Int
    function EffortLevel{K}(index::Integer) where K
        0 <= index <= K || throw(ArgumentError("effort level must lie in 0:$K"))
        new{K}(Int(index))
    end
end

effort_levels(::EffortGrid{K}) where K = EffortLevel{K}.(0:K)
effort_value(::EffortGrid{K}, level::EffortLevel{K}) where K = level.index / K
effort_value(::ContinuousEffort, effort::Real) = Float64(effort)

"""Compile-time bounds for the explicitly finite model family."""
struct FiniteModelBounds{N,F} end

function FiniteModelBounds(agent_slots::Integer, firm_slots::Integer)
    agent_slots > 0 || throw(ArgumentError("agent slots must be positive"))
    firm_slots > 0 || throw(ArgumentError("firm slots must be positive"))
    FiniteModelBounds{Int(agent_slots),Int(firm_slots)}()
end

struct FiniteAgentId{N}
    index::Int
    function FiniteAgentId{N}(index::Integer) where N
        1 <= index <= N || throw(ArgumentError("finite agent ID must lie in 1:$N"))
        new{N}(Int(index))
    end
end

struct FiniteFirmId{F}
    index::Int
    function FiniteFirmId{F}(index::Integer) where F
        1 <= index <= F || throw(ArgumentError("finite firm ID must lie in 1:$F"))
        new{F}(Int(index))
    end
end

struct FiniteAgentState{N,F,K}
    theta::EffortLevel{K}
    effort::EffortLevel{K}
    firm_id::FiniteFirmId{F}
    neighbors::Set{FiniteAgentId{N}}
end

struct FiniteModelState{N,F,K}
    agents::NTuple{N,Union{Nothing,FiniteAgentState{N,F,K}}}
    active_firms::Set{FiniteFirmId{F}}
    next_agent::Union{Nothing,FiniteAgentId{N}}
    next_firm::Union{Nothing,FiniteFirmId{F}}
end

agent_ids(::FiniteModelBounds{N,F}) where {N,F} = FiniteAgentId{N}.(1:N)
firm_ids(::FiniteModelBounds{N,F}) where {N,F} = FiniteFirmId{F}.(1:F)

struct FiniteAction{F,K}
    effort::EffortLevel{K}
    firm_id::FiniteFirmId{F}
end

struct FiniteDraw{N,T}
    selected_agent::FiniteAgentId{N}
    tie_break::Int
    function FiniteDraw{N,T}(selected_agent::FiniteAgentId{N}, tie_break::Integer) where {N,T}
        0 <= tie_break < T || throw(ArgumentError("finite tie break must lie in 0:$(T-1)"))
        new{N,T}(selected_agent, Int(tie_break))
    end
end

is_candidate_firm(state::FiniteModelState, agent::FiniteAgentState, firm::FiniteFirmId) =
    firm == agent.firm_id || firm in state.active_firms || state.next_firm == firm

finite_valid(state::FiniteModelState) =
    state.active_firms == Set(agent.firm_id for agent in state.agents if !isnothing(agent))

function finite_transition(state::FiniteModelState{N,F,K}, draw::FiniteDraw{N,T},
                           choose) where {N,F,K,T}
    agent = state.agents[draw.selected_agent.index]
    isnothing(agent) && return state
    action = choose(state, draw)
    isnothing(action) && return state

    updated = FiniteAgentState(agent.theta, action.effort, action.firm_id, agent.neighbors)
    agents = ntuple(N) do index
        index == draw.selected_agent.index ? updated : state.agents[index]
    end
    active_firms = Set(entry.firm_id for entry in agents if !isnothing(entry))
    next_firm = state.next_firm == action.firm_id && action.firm_id.index < F ?
        FiniteFirmId{F}(action.firm_id.index + 1) :
        (state.next_firm == action.firm_id ? nothing : state.next_firm)
    FiniteModelState(agents, active_firms, state.next_agent, next_firm)
end
