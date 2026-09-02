function utility(theta::Real, effort::Real, others_effort::Real, firm_size::Int,
                 params::ModelParams)
    0.0 <= theta <= 1.0 || return -Inf
    0.0 <= effort <= 1.0 || return -Inf
    firm_size > 0 || return -Inf
    candidate_income = production(effort + others_effort, params) / firm_size
    candidate_income < 0 && return -Inf
    candidate_income^theta * (1.0 - effort)^(1.0 - theta)
end
