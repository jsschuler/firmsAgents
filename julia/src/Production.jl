production(total_effort::Real, params::ModelParams) =
    params.a * total_effort + params.b * total_effort^params.beta

firm_output(state::ModelState, firm_id::FirmId, params::ModelParams) =
    production(firm_effort(state, firm_id), params)

function income(state::ModelState, agent_id::AgentId, params::ModelParams)
    agent = only(filter(agent -> agent.id == agent_id, state.agents))
    members = firm_members(state, agent.firm_id)
    firm_output(state, agent.firm_id, params) / length(members)
end
