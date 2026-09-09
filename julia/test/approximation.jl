@testset "finite effort grid" begin
    grid = EffortGrid(4)
    levels = effort_levels(grid)

    @test length(levels) == 5
    @test effort_value.(Ref(grid), levels) == [0.0, 0.25, 0.5, 0.75, 1.0]
    @test effort_value(ContinuousEffort(), 0.375) == 0.375
    @test_throws ArgumentError EffortGrid(0)
    @test_throws ArgumentError EffortLevel{4}(5)
end

@testset "exact finite transition matrix" begin
    bounds = FiniteModelBounds(1, 2)
    agent = FiniteAgentState(EffortLevel{1}(0), EffortLevel{1}(0),
        FiniteFirmId{2}(1), Set{FiniteAgentId{1}}())
    initial = FiniteModelState((agent,), Set([FiniteFirmId{2}(1)]), nothing,
        FiniteFirmId{2}(2))
    draws = finite_draws(bounds, Val(2))
    action = FiniteAction(EffortLevel{1}(1), FiniteFirmId{2}(2))
    choose = (state, draw) ->
        draw.tie_break == 0 || state.next_firm != action.firm_id ? nothing : action
    moved = finite_transition(initial, draws[2], choose)
    states = [initial, moved]
    fixture_path = joinpath(@__DIR__, "..", "..", "spec", "fixtures",
        "two-state-kernel.txt")
    fixture = Dict(split(line, "="; limit=2) for line in readlines(fixture_path)
                   if !isempty(line) && !startswith(line, "#"))
    denominator = parse(Int, fixture["denominator"])
    expected_counts = reduce(vcat, [permutedims(parse.(Int, split(fixture[name], ",")))
                                    for name in ("initial", "moved")])
    probabilities = fill(1 // denominator, length(draws))
    matrix = finite_transition_matrix(states, draws, probabilities, choose)

    @test length(draws) == 2
    @test matrix == expected_counts .// denominator
    @test vec(sum(matrix; dims=2)) == Rational{Int}[1//1, 1//1]
    initial_distribution = Rational{Int}[1//1, 0//1]
    @test finite_distribution_after(initial_distribution, matrix, 0) ==
        initial_distribution
    @test finite_distribution_after(initial_distribution, matrix, 1) ==
        Rational{Int}[1//2, 1//2]
    @test finite_distribution_after(initial_distribution, matrix, 2) ==
        Rational{Int}[1//4, 3//4]
    @test is_stationary_distribution(Rational{Int}[0//1, 1//1], matrix)
    @test !is_stationary_distribution(initial_distribution, matrix)
    @test finite_transition_adjacency(matrix) == Bool[1 1; 0 1]
    @test finite_reachability(matrix) == Bool[1 1; 0 1]
    @test finite_communicating_classes(matrix) == [[1], [2]]
    @test finite_closed_classes(matrix) == [[2]]
    @test finite_absorbing_states(matrix) == [2]
    @test !finite_irreducible(matrix)
    @test finite_class_periods(matrix) == [1, 1]
    @test finite_aperiodic(matrix)
    two_cycle = Rational{Int}[0//1 1//1; 1//1 0//1]
    @test finite_irreducible(two_cycle)
    @test finite_class_periods(two_cycle) == [2]
    @test !finite_aperiodic(two_cycle)
    @test_throws ArgumentError finite_distribution_after(initial_distribution, matrix, -1)
    @test_throws ArgumentError finite_transition_matrix(states, draws,
        Rational{Int}[1//3, 1//3], choose)
    @test_throws ArgumentError finite_transition_matrix([initial], draws,
        probabilities, choose)
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
    @test finite_graph_valid(state)
    updated = finite_transition(state, draw, (_, _) -> action)
    @test updated.agents[1].effort.index == 4
    @test updated.agents[1].firm_id == FiniteFirmId{3}(3)
    @test updated.next_firm === nothing
    @test finite_valid(updated)
    @test finite_graph_valid(updated)
    @test finite_transition(state, draw, (_, _) -> nothing) === state
    invalid = FiniteModelState(state.agents, Set([FiniteFirmId{3}(1)]),
        state.next_agent, state.next_firm)
    @test !finite_valid(invalid)
    self_neighbor = FiniteAgentState(first_agent.theta, first_agent.effort,
        first_agent.firm_id, Set([FiniteAgentId{2}(1)]))
    @test !finite_graph_valid(FiniteModelState((self_neighbor, second_agent),
        state.active_firms, state.next_agent, state.next_firm))
    missing_neighbor = FiniteModelState((first_agent, nothing),
        Set([FiniteFirmId{3}(1)]), nothing, FiniteFirmId{3}(2))
    @test !finite_graph_valid(missing_neighbor)
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

@testset "finite firm-size tail observables" begin
    joined_agent = FiniteAgentState(EffortLevel{2}(1), EffortLevel{2}(1),
        FiniteFirmId{2}(1), Set([FiniteAgentId{2}(2)]))
    joined_peer = FiniteAgentState(EffortLevel{2}(1), EffortLevel{2}(1),
        FiniteFirmId{2}(1), Set([FiniteAgentId{2}(1)]))
    joined = FiniteModelState((joined_agent, joined_peer),
        Set([FiniteFirmId{2}(1)]), nothing, FiniteFirmId{2}(2))
    split_peer = FiniteAgentState(joined_peer.theta, joined_peer.effort,
        FiniteFirmId{2}(2), joined_peer.neighbors)
    split = FiniteModelState((joined_agent, split_peer),
        Set([FiniteFirmId{2}(1), FiniteFirmId{2}(2)]), nothing, nothing)
    weights = Rational{Int}[1//2, 1//2]

    @test sort(finite_firm_sizes(joined)) == [2]
    @test sort(finite_firm_sizes(split)) == [1, 1]
    expected = finite_expected_size_counts([joined, split], weights)
    @test expected == Dict(1 => 1//1, 2 => 1//2)
    @test finite_size_ccdf(expected) == Dict(1 => 1//1, 2 => 1//3)
    @test_throws ArgumentError finite_expected_size_counts([joined, split],
        Rational{Int}[1//4, 1//4])
end

@testset "small economic finite kernel" begin
    bounds = FiniteModelBounds(2, 3)
    grid = EffortGrid(2)
    first = FiniteAgentState(EffortLevel{2}(1), EffortLevel{2}(1),
        FiniteFirmId{3}(1), Set([FiniteAgentId{2}(2)]))
    second = FiniteAgentState(EffortLevel{2}(1), EffortLevel{2}(1),
        FiniteFirmId{3}(2), Set([FiniteAgentId{2}(1)]))
    initial = FiniteModelState((first, second),
        Set([FiniteFirmId{3}(1), FiniteFirmId{3}(2)]), nothing, FiniteFirmId{3}(3))
    draws = finite_draws(bounds, Val(2))
    rule = FiniteBestResponseRule(grid,
        ModelParams(n_max=2, neighbors_per_agent=1))
    states = finite_reachable_states(initial, draws, rule)
    probabilities = fill(1 // length(draws), length(draws))
    matrix = finite_transition_matrix(states, draws, probabilities, rule)

    @test length(states) == 3
    @test all(finite_valid, states)
    @test all(finite_graph_valid, states)
    @test all(==(1//1), vec(sum(matrix; dims=2)))
    @test matrix == Rational{Int}[0//1 1//2 1//2; 0//1 1//1 0//1; 0//1 0//1 1//1]
    @test finite_communicating_classes(matrix) == [[1], [2], [3]]
    @test finite_closed_classes(matrix) == [[2], [3]]
    @test finite_absorbing_states(matrix) == [2, 3]
    @test finite_class_periods(matrix) == [0, 1, 1]
    @test !finite_irreducible(matrix)
    @test !finite_aperiodic(matrix)
    @test finite_distribution_after(Rational{Int}[1//1, 0//1, 0//1], matrix, 1) ==
        Rational{Int}[0//1, 1//2, 1//2]
    @test finite_closed_class_absorption(matrix, 1) == Rational{Int}[1//2, 1//2]
    @test all(state -> finite_firm_sizes(state) == [2], states[2:3])
end

@testset "three-agent economic recurrent structure" begin
    bounds = FiniteModelBounds(3, 4)
    grid = EffortGrid(2)
    agents = ntuple(3) do index
        FiniteAgentState(EffortLevel{2}(1), EffortLevel{2}(1),
            FiniteFirmId{4}(index),
            Set(FiniteAgentId{3}(neighbor) for neighbor in 1:3 if neighbor != index))
    end
    initial = FiniteModelState(agents, Set(FiniteFirmId{4}.(1:3)), nothing,
        FiniteFirmId{4}(4))
    draws = finite_draws(bounds, Val(2))
    rule = FiniteBestResponseRule(grid,
        ModelParams(n_max=3, neighbors_per_agent=2))
    states = finite_reachable_states(initial, draws, rule)
    matrix = finite_transition_matrix(states, draws,
        fill(1 // length(draws), length(draws)), rule)
    closed = finite_closed_classes(matrix)
    absorption = finite_closed_class_absorption(matrix, 1)

    @test length(states) == 85
    @test length(finite_communicating_classes(matrix)) == 55
    @test length(closed) == 12
    @test all(==(1), length.(closed))
    @test length(finite_absorbing_states(matrix)) == 12
    @test absorption == Rational{Int}[1//4, 23//900, 1//4, 29//900, 1//4,
        23//900, 29//900, 29//900, 23//900, 23//900, 23//900, 23//900]
    @test sum(absorption) == 1//1
    @test all(>=(0//1), absorption)
    @test all(class -> finite_firm_sizes(states[only(class)]) == [3], closed)
end

@testset "four-agent nonlinear competing terminal compositions" begin
    bounds = FiniteModelBounds(4, 5)
    grid = EffortGrid(2)
    theta_indices = [2, 1, 2, 2]
    neighbor_lists = [[2], [1], [4], [1, 3]]
    agents = ntuple(4) do index
        FiniteAgentState(EffortLevel{2}(theta_indices[index]), EffortLevel{2}(1),
            FiniteFirmId{5}(index),
            Set(FiniteAgentId{4}.(neighbor_lists[index])))
    end
    initial = FiniteModelState(agents, Set(FiniteFirmId{5}.(1:4)), nothing,
        FiniteFirmId{5}(5))
    draws = finite_draws(bounds, Val(2))
    rule = FiniteBestResponseRule(grid,
        ModelParams(n_max=4, neighbors_per_agent=2, b=1.0))
    states = finite_reachable_states(initial, draws, rule)
    matrix = finite_transition_matrix(states, draws,
        fill(1 // length(draws), length(draws)), rule)
    closed = finite_closed_classes(matrix)
    absorption = finite_closed_class_absorption(matrix, 1)
    compositions = [Tuple(sort(finite_firm_sizes(states[only(class)]))) for class in closed]
    composition_mass = Dict(composition =>
        sum((probability for (probability, terminal) in zip(absorption, compositions)
             if terminal == composition); init=0//1)
        for composition in unique(compositions))

    @test length(states) == 120
    @test length(finite_communicating_classes(matrix)) == 108
    @test length(closed) == 9
    @test all(==(1), length.(closed))
    @test length(finite_absorbing_states(matrix)) == 9
    @test count(==((2, 2)), compositions) == 6
    @test count(==((4,)), compositions) == 3
    @test composition_mass == Dict(
        (2, 2) => 192865369//301644000,
        (4,) => 108778631//301644000)
    @test sum(absorption) == 1//1
end
