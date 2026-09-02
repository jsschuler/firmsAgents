function optimal_effort(theta::Real, others_effort::Real, firm_size::Int,
                        params::ModelParams)
    left, right = 0.0, 1.0
    ratio = (sqrt(5.0) - 1.0) / 2.0
    x1 = right - ratio * (right - left)
    x2 = left + ratio * (right - left)
    objective(effort) = utility(theta, effort, others_effort, firm_size, params)
    while right - left > params.optimization_tolerance
        if objective(x1) < objective(x2)
            left = x1
            x1 = x2
            x2 = left + ratio * (right - left)
        else
            right = x2
            x2 = x1
            x1 = right - ratio * (right - left)
        end
    end
    choices = (0.0, (left + right) / 2.0, 1.0)
    values = objective.(choices)
    choices[argmax(values)]
end

function choose_alternative(state::ModelState, agent::AgentState, draw::Draw,
                            params::ModelParams)
    alternatives = map(candidate_firms(state, agent)) do candidate
        others_effort, size = candidate_conditions(state, agent, candidate)
        effort = optimal_effort(agent.theta, others_effort, size, params)
        welfare = utility(agent.theta, effort, others_effort, size, params)
        (; candidate, effort, welfare)
    end
    maximum_welfare = maximum(alt.welfare for alt in alternatives)
    tied = filter(alt -> maximum_welfare - alt.welfare <= params.utility_tolerance, alternatives)
    tied[Int(mod(draw.tie_break, UInt64(length(tied)))) + 1]
end
