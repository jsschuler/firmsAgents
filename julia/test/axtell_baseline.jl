function small_state()
    agents = [
        AgentState(AgentId(1), 0.4, 0.2, FirmId(1), [AgentId(2)], 0.0, nothing, 0),
        AgentState(AgentId(2), 0.6, 0.3, FirmId(1), [AgentId(3)], 0.0, nothing, 0),
        AgentState(AgentId(3), 0.5, 0.4, FirmId(3), [AgentId(2)], 0.0, nothing, 0),
    ]
    ModelState(agents, [FirmState(FirmId(1)), FirmState(FirmId(3))], 4, 4)
end

@testset "Axtell mathematical primitives" begin
    params = ModelParams(n_max=3, neighbors_per_agent=1)
    state = small_state()
    @test production(2.0, params) == 6.0
    @test firm_effort(state, FirmId(1)) == 0.5
    @test firm_output(state, FirmId(1), params) == 0.75
    @test income(state, AgentId(1), params) == 0.375
    @test utility(0.5, 0.5, 0.0, 1, params) ≈ sqrt(0.75 * 0.5)
    optimum = optimal_effort(0.5, 0.3, 2, params)
    @test 0.0 <= optimum <= 1.0
    grid = range(0.0, 1.0; length=10_001)
    @test utility(0.5, optimum, 0.3, 2, params) + 1e-8 >=
          maximum(effort -> utility(0.5, effort, 0.3, 2, params), grid)
end

@testset "local candidates only" begin
    state = small_state()
    candidates = candidate_firms(state, state.agents[1])
    @test [(candidate.firm_id.value, candidate.startup) for candidate in candidates] ==
          [(1, false), (4, true)]
    candidates = candidate_firms(state, state.agents[2])
    @test [(candidate.firm_id.value, candidate.startup) for candidate in candidates] ==
          [(1, false), (3, false), (4, true)]
end

@testset "Axtell base-case initialization" begin
    params = axtell_base_case()
    state1 = initialize(Xoshiro(42), params)
    state2 = initialize(Xoshiro(42), params)
    @test state1 == state2
    @test valid(state1, params)
    @test length(state1.agents) == 1000
    @test length(state1.firms) == 1000
    @test all(length(agent.neighbors) == 2 for agent in state1.agents)
    @test all(agent.effort == 0.5 for agent in state1.agents)
end

@testset "event transition and recovery" begin
    params = ModelParams(n_max=3, neighbors_per_agent=1)
    config = baseline_config()
    initial = small_state()
    draws = [Draw(AgentId(mod1(index, 3)), UInt64(index), UInt64[]) for index in 1:30]
    states = trajectory(initial, draws, config, params)
    @test length(states) == 31
    @test all(state -> valid(state, params), states)
    @test all(state -> length(state.agents) == 3, states)
    @test all(state -> all(firm -> !isempty(firm_members(state, firm.id)), state.firms), states)

    baseline = ModelState[initial]
    for draw in draws
        push!(baseline, baseline_transition(baseline[end], draw, params))
    end
    @test states == baseline
    @test trajectory(initial, draws, config, params) == states
end

@testset "RNG purity and reproducibility" begin
    params = ModelParams(n_max=3, neighbors_per_agent=1)
    state = small_state()
    rng1, rng2 = Xoshiro(7), Xoshiro(7)
    draws1 = [sample_draw(rng1, state, baseline_config(), params) for _ in 1:20]
    draws2 = [sample_draw(rng2, state, baseline_config(), params) for _ in 1:20]
    @test draws1 == draws2
    @test trajectory(state, draws1, baseline_config(), params) ==
          trajectory(state, draws2, baseline_config(), params)
end
