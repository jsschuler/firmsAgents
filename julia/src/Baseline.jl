function baseline_candidate(state::ModelState, draw::Draw, params::ModelParams)
    index = findfirst(agent -> agent.id == draw.selected_agent, state.agents)
    isnothing(index) && return state
    agent = state.agents[index]
    choice = choose_alternative(state, agent, draw, params)
    agents = copy(state.agents)
    agents[index] = AgentState(agent.id, agent.theta, choice.effort,
                               choice.candidate.firm_id, agent.neighbors,
                               agent.compute, agent.parent, agent.specialization)
    active_ids = unique(getfield.(agents, :firm_id))
    firms = FirmState.(sort(active_ids; by=id -> id.value))
    next_firm_id = choice.candidate.startup ? state.next_firm_id + 1 : state.next_firm_id
    ModelState(agents, firms, state.next_agent_id, next_firm_id)
end

function baseline_transition(state::ModelState, draw::Draw, params::ModelParams)
    candidate = baseline_candidate(state, draw, params)
    valid(candidate, params) ? candidate : state
end
