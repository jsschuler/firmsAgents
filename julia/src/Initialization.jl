function initialize(rng::AbstractRNG, params::ModelParams=axtell_base_case())
    valid(params) || throw(ArgumentError("invalid Axtell parameters"))
    ids = AgentId.(1:params.n_max)
    agents = map(ids) do id
        pool = filter(!=(id), ids)
        neighbors = AgentId[]
        for _ in 1:params.neighbors_per_agent
            index = rand(rng, eachindex(pool))
            push!(neighbors, pool[index])
            deleteat!(pool, index)
        end
        AgentState(id, rand(rng), params.initial_effort, FirmId(id.value),
                   neighbors, 0.0, nothing, 0)
    end
    firms = FirmState.(FirmId.(1:params.n_max))
    ModelState(agents, firms, params.n_max + 1, params.n_max + 1)
end
