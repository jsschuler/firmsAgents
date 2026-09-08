@testset "finite effort grid" begin
    grid = EffortGrid(4)
    levels = effort_levels(grid)

    @test length(levels) == 5
    @test effort_value.(Ref(grid), levels) == [0.0, 0.25, 0.5, 0.75, 1.0]
    @test effort_value(ContinuousEffort(), 0.375) == 0.375
    @test_throws ArgumentError EffortGrid(0)
    @test_throws ArgumentError EffortLevel{4}(5)
end


@testset "deterministic finite transition" begin
    first_agent = FiniteAgentState(
        EffortLevel{4}(2), EffortLevel{4}(2), FiniteFirmId{3}(1),
        Set([FiniteAgentId{2}(2)]),
    )
    second_agent = FiniteAgentState(
        EffortLevel{4}(3), EffortLevel{4}(1), FiniteFirmId{3}(2),
        Set([FiniteAgentId{2}(1)]),
    )
    state = FiniteModelState((first_agent, second_agent),
        Set([FiniteFirmId{3}(1), FiniteFirmId{3}(2)]), nothing, FiniteFirmId{3}(3))
    draw = FiniteDraw{2,8}(FiniteAgentId{2}(1), 5)
    action = FiniteAction(EffortLevel{4}(4), FiniteFirmId{3}(3))

    @test is_candidate_firm(state, first_agent, action.firm_id)
    @test finite_valid(state)
    updated = finite_transition(state, draw, (_, _) -> action)
    @test updated.agents[1].effort.index == 4
    @test updated.agents[1].firm_id == FiniteFirmId{3}(3)
    @test updated.next_firm === nothing
    @test finite_valid(updated)
    @test finite_transition(state, draw, (_, _) -> nothing) === state
    invalid = FiniteModelState(state.agents, Set([FiniteFirmId{3}(1)]),
        state.next_agent, state.next_firm)
    @test !finite_valid(invalid)
    @test_throws ArgumentError FiniteDraw{2,8}(FiniteAgentId{2}(1), 8)
end

@testset "bounded finite identifiers and state" begin
    bounds = FiniteModelBounds(3, 4)
    @test getfield.(agent_ids(bounds), :index) == 1:3
    @test getfield.(firm_ids(bounds), :index) == 1:4
    @test_throws ArgumentError FiniteModelBounds(0, 4)
    @test_throws ArgumentError FiniteAgentId{3}(4)
    @test_throws ArgumentError FiniteFirmId{4}(0)

    agent = FiniteAgentState(
        EffortLevel{4}(2), EffortLevel{4}(3), FiniteFirmId{4}(1),
        Set([FiniteAgentId{3}(2)]),
    )
    state = FiniteModelState((agent, nothing, nothing),
        Set([FiniteFirmId{4}(1)]), FiniteAgentId{3}(2), FiniteFirmId{4}(2))
    @test state.agents[1] === agent
end
