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

Base.:(==)(left::FiniteAgentState, right::FiniteAgentState) =
    left.theta == right.theta && left.effort == right.effort &&
    left.firm_id == right.firm_id && left.neighbors == right.neighbors

Base.:(==)(left::FiniteModelState, right::FiniteModelState) =
    left.agents == right.agents && left.active_firms == right.active_firms &&
    left.next_agent == right.next_agent && left.next_firm == right.next_firm

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

"""Enumerate the complete bounded draw space for an exact finite kernel."""
finite_draws(::FiniteModelBounds{N,F}, ::Val{T}) where {N,F,T} =
    [FiniteDraw{N,T}(FiniteAgentId{N}(agent), tie)
     for agent in 1:N for tie in 0:(T - 1)]

is_candidate_firm(state::FiniteModelState, agent::FiniteAgentState, firm::FiniteFirmId) =
    firm == agent.firm_id || firm in state.active_firms || state.next_firm == firm

finite_valid(state::FiniteModelState) =
    state.active_firms == Set(agent.firm_id for agent in state.agents if !isnothing(agent))

function finite_graph_valid(state::FiniteModelState{N}) where N
    active = Set(FiniteAgentId{N}(index) for index in eachindex(state.agents)
                 if !isnothing(state.agents[index]))
    all(eachindex(state.agents)) do index
        agent = state.agents[index]
        isnothing(agent) && return true
        id = FiniteAgentId{N}(index)
        id ∉ agent.neighbors && issubset(agent.neighbors, active)
    end
end

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

"""Build an exact row-stochastic matrix by pushing a finite draw distribution
through `finite_transition`. Every successor must occur in `states`."""
function finite_transition_matrix(states::AbstractVector{S}, draws::AbstractVector{D},
                                  draw_probabilities::AbstractVector{P}, choose) where {S,D,P}
    isempty(states) && throw(ArgumentError("state enumeration must be nonempty"))
    all(states[left] != states[right]
        for left in eachindex(states) for right in (left + 1):lastindex(states)) ||
        throw(ArgumentError("state enumeration must not contain duplicates"))
    length(draws) == length(draw_probabilities) ||
        throw(ArgumentError("draws and probabilities must have equal length"))
    all(probability -> probability >= zero(P), draw_probabilities) ||
        throw(ArgumentError("draw probabilities must be nonnegative"))
    sum(draw_probabilities; init=zero(P)) == one(P) ||
        throw(ArgumentError("draw probabilities must sum exactly to one"))

    matrix = fill(zero(P), length(states), length(states))
    for (row, state) in pairs(states), (draw, probability) in zip(draws, draw_probabilities)
        successor = finite_transition(state, draw, choose)
        column = findfirst(==(successor), states)
        isnothing(column) && throw(ArgumentError("state enumeration is not transition-closed"))
        matrix[row, column] += probability
    end
    matrix
end

"""Propagate a row distribution through an exact finite transition matrix."""
function finite_distribution_after(distribution::AbstractVector, matrix::AbstractMatrix,
                                   steps::Integer)
    steps >= 0 || throw(ArgumentError("step count must be nonnegative"))
    size(matrix, 1) == size(matrix, 2) == length(distribution) ||
        throw(DimensionMismatch("distribution and square transition matrix must align"))
    result = collect(distribution)
    for _ in 1:steps
        result = vec(transpose(result) * matrix)
    end
    result
end

"""Exact stationarity predicate for a row distribution."""
is_stationary_distribution(distribution::AbstractVector, matrix::AbstractMatrix) =
    finite_distribution_after(distribution, matrix, 1) == distribution

"""Occupied firm sizes in a finite approximation state."""
function finite_firm_sizes(state::FiniteModelState)
    [count(agent -> !isnothing(agent) && agent.firm_id == firm, state.agents)
     for firm in state.active_firms]
end

"""Expected number of firms of each size under a finite state distribution.
The result is an exact count measure when the supplied weights are exact."""
function finite_expected_size_counts(states::AbstractVector,
                                     distribution::AbstractVector{P}) where P
    length(states) == length(distribution) ||
        throw(DimensionMismatch("states and distribution must align"))
    all(weight -> weight >= zero(P), distribution) ||
        throw(ArgumentError("state probabilities must be nonnegative"))
    sum(distribution; init=zero(P)) == one(P) ||
        throw(ArgumentError("state probabilities must sum exactly to one"))
    counts = Dict{Int,P}()
    for (state, weight) in zip(states, distribution), size in finite_firm_sizes(state)
        counts[size] = get(counts, size, zero(P)) + weight
    end
    counts
end

"""Firm-weighted complementary size distribution derived from expected counts."""
function finite_size_ccdf(expected_counts::AbstractDict{Int,P}) where P
    total = sum(values(expected_counts); init=zero(P))
    total > zero(P) || throw(ArgumentError("expected firm count must be positive"))
    Dict(threshold => sum((weight for (size, weight) in expected_counts
                           if size >= threshold); init=zero(P)) / total
         for threshold in sort(collect(keys(expected_counts))))
end

function finite_transition_adjacency(matrix::AbstractMatrix)
    size(matrix, 1) == size(matrix, 2) ||
        throw(DimensionMismatch("transition matrix must be square"))
    matrix .> zero(eltype(matrix))
end

"""Reflexive-transitive closure of the positive transition graph."""
function finite_reachability(matrix::AbstractMatrix)
    reachable = finite_transition_adjacency(matrix)
    for state in axes(reachable, 1)
        reachable[state, state] = true
    end
    for middle in axes(reachable, 1), source in axes(reachable, 1), target in axes(reachable, 1)
        reachable[source, target] |= reachable[source, middle] && reachable[middle, target]
    end
    reachable
end

function finite_communicating_classes(matrix::AbstractMatrix)
    reachable = finite_reachability(matrix)
    remaining = Set(axes(reachable, 1))
    classes = Vector{Vector{Int}}()
    while !isempty(remaining)
        representative = minimum(remaining)
        class = sort([state for state in remaining
                      if reachable[representative, state] && reachable[state, representative]])
        push!(classes, class)
        setdiff!(remaining, class)
    end
    classes
end

function finite_closed_classes(matrix::AbstractMatrix)
    adjacency = finite_transition_adjacency(matrix)
    filter(finite_communicating_classes(matrix)) do class
        members = Set(class)
        all(!adjacency[source, target] || target in members
            for source in class for target in axes(adjacency, 2))
    end
end

function finite_absorbing_states(matrix::AbstractMatrix)
    size(matrix, 1) == size(matrix, 2) ||
        throw(DimensionMismatch("transition matrix must be square"))
    [state for state in axes(matrix, 1)
     if all(matrix[state, target] == (state == target ? one(eltype(matrix)) : zero(eltype(matrix)))
            for target in axes(matrix, 2))]
end

finite_irreducible(matrix::AbstractMatrix) = all(finite_reachability(matrix))

"""Graph period of each communicating class, computed as the gcd of depth
differences around positive edges. A zero period means the class has no cycle."""
function finite_class_periods(matrix::AbstractMatrix)
    adjacency = finite_transition_adjacency(matrix)
    [begin
        members = Set(class)
        depth = Dict(first(class) => 0)
        queue = [first(class)]
        while !isempty(queue)
            source = popfirst!(queue)
            for target in class
                if adjacency[source, target] && !haskey(depth, target)
                    depth[target] = depth[source] + 1
                    push!(queue, target)
                end
            end
        end
        period = 0
        for source in class, target in class
            adjacency[source, target] || continue
            period = gcd(period, abs(depth[source] + 1 - depth[target]))
        end
        period
    end for class in finite_communicating_classes(matrix)]
end

finite_aperiodic(matrix::AbstractMatrix) = all(==(1), finite_class_periods(matrix))

"""Probability of eventual entry into each closed communicating class.
Solves the finite Dirichlet equations exactly when `matrix` has exact entries."""
function finite_closed_class_absorption(matrix::AbstractMatrix{T}, initial::Integer) where T
    size(matrix, 1) == size(matrix, 2) ||
        throw(DimensionMismatch("transition matrix must be square"))
    initial in axes(matrix, 1) || throw(BoundsError(matrix, initial))
    classes = finite_closed_classes(matrix)
    closed_states = Set(Iterators.flatten(classes))
    if initial in closed_states
        return T[initial in class ? one(T) : zero(T) for class in classes]
    end
    transient = [state for state in axes(matrix, 1) if state ∉ closed_states]
    transient_position = only(findall(==(initial), transient))
    S = T <: Rational ? Rational{BigInt} : T
    system = [(row == column ? one(S) : zero(S)) -
              convert(S, matrix[transient[row], transient[column]])
              for row in eachindex(transient), column in eachindex(transient)]
    boundaries = [sum((convert(S, matrix[state, target]) for target in class); init=zero(S))
                  for state in transient, class in classes]
    vec((system \ boundaries)[transient_position, :])
end

"""Grid-dispatched finite analogue of the baseline utility-maximizing rule."""
struct FiniteBestResponseRule{G,P}
    grid::G
    params::P
end

function finite_candidate_firms(state::FiniteModelState, agent::FiniteAgentState)
    firms = Set([agent.firm_id])
    for neighbor_id in agent.neighbors
        neighbor = state.agents[neighbor_id.index]
        isnothing(neighbor) || push!(firms, neighbor.firm_id)
    end
    isnothing(state.next_firm) || push!(firms, state.next_firm)
    sort!(collect(firms); by=firm -> firm.index)
end

function (rule::FiniteBestResponseRule{<:EffortGrid{K}})(
        state::FiniteModelState{N,F,K}, draw::FiniteDraw{N,T}) where {N,F,K,T}
    agent = state.agents[draw.selected_agent.index]
    isnothing(agent) && return nothing
    theta = effort_value(rule.grid, agent.theta)
    scored = Tuple{Float64,FiniteAction{F,K}}[]
    for firm in finite_candidate_firms(state, agent), level in effort_levels(rule.grid)
        members = [(index, member) for (index, member) in pairs(state.agents)
                   if !isnothing(member) && member.firm_id == firm]
        others = sum((effort_value(rule.grid, member.effort)
                      for (index, member) in members if index != draw.selected_agent.index);
                     init=0.0)
        size = length(members) + (agent.firm_id == firm ? 0 : 1)
        value = utility(theta, effort_value(rule.grid, level), others, size, rule.params)
        push!(scored, (value, FiniteAction(level, firm)))
    end
    best = maximum(first, scored)
    maximizers = [action for (value, action) in scored
                  if value >= best - rule.params.utility_tolerance]
    maximizers[mod(draw.tie_break, length(maximizers)) + 1]
end

"""Discover the transition-closed state set reachable from one initial state."""
function finite_reachable_states(initial::S, draws::AbstractVector, choose;
                                 max_states::Integer=100_000) where S
    states = S[initial]
    frontier = 1
    while frontier <= length(states)
        state = states[frontier]
        for draw in draws
            successor = finite_transition(state, draw, choose)
            isnothing(findfirst(==(successor), states)) && push!(states, successor)
            length(states) <= max_states ||
                throw(ArgumentError("reachable state set exceeded max_states"))
        end
        frontier += 1
    end
    states
end
