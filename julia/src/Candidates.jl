struct FirmCandidate
    firm_id::FirmId
    startup::Bool
end

function candidate_firms(state::ModelState, agent::AgentState)
    candidates = FirmCandidate[FirmCandidate(agent.firm_id, false)]
    for neighbor_id in agent.neighbors
        neighbor = only(filter(other -> other.id == neighbor_id, state.agents))
        if all(candidate -> candidate.firm_id != neighbor.firm_id, candidates)
            push!(candidates, FirmCandidate(neighbor.firm_id, false))
        end
    end
    next_firm = FirmId(state.next_firm_id)
    push!(candidates, FirmCandidate(next_firm, true))
    candidates
end

function candidate_conditions(state::ModelState, agent::AgentState, candidate::FirmCandidate)
    candidate.startup && return (0.0, 1)
    members = firm_members(state, candidate.firm_id)
    others_effort = sum((member.effort for member in members if member.id != agent.id); init=0.0)
    size = length(members) + (agent.firm_id == candidate.firm_id ? 0 : 1)
    (others_effort, size)
end
