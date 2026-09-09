firm_sizes(state::ModelState) = Dict(
    firm.id => length(firm_members(state, firm.id)) for firm in state.firms
)

"""Finite-sample normalized Gini coefficient. The `n/(n-1)` correction makes
the maximum attainable inequality equal to one for any sample size `n > 1`."""
function normalized_gini(values::AbstractVector{<:Real})
    isempty(values) && throw(ArgumentError("Gini sample must be nonempty"))
    all(>=(0), values) || throw(ArgumentError("Gini values must be nonnegative"))
    total = sum(values)
    total > 0 || throw(ArgumentError("Gini total must be positive"))
    length(values) == 1 && return 0.0
    ordered = sort(values)
    n = length(ordered)
    weighted = sum((2index - n - 1) * value for (index, value) in enumerate(ordered))
    weighted / ((n - 1) * total)
end

firm_outputs(state::ModelState, params::ModelParams) = Dict(
    firm.id => firm_output(state, firm.id, params) for firm in state.firms
)

aggregate_output(state::ModelState, params::ModelParams) =
    sum(values(firm_outputs(state, params)); init=0.0)

function aggregate_productivity(state::ModelState, params::ModelParams)
    total_effort = sum(agent.effort for agent in state.agents; init=0.0)
    total_effort == 0.0 ? NaN : aggregate_output(state, params) / total_effort
end

effort_distribution(state::ModelState) = getfield.(state.agents, :effort)

income_distribution(state::ModelState, params::ModelParams) =
    [income(state, agent.id, params) for agent in state.agents]

function utility_distribution(state::ModelState, params::ModelParams)
    map(state.agents) do agent
        members = firm_members(state, agent.firm_id)
        others = sum((member.effort for member in members if member.id != agent.id); init=0.0)
        utility(agent.theta, agent.effort, others, length(members), params)
    end
end

"""Log output growth for firm IDs active in both adjacent snapshots."""
function firm_log_growth(previous::ModelState, current::ModelState, params::ModelParams)
    before = firm_outputs(previous, params)
    after = firm_outputs(current, params)
    common = intersect(keys(before), keys(after))
    Dict(id => log(after[id] / before[id]) for id in common
         if before[id] > 0.0 && after[id] > 0.0)
end

function sample_std(values)
    length(values) <= 1 && return 0.0
    mean_value = sum(values) / length(values)
    sqrt(sum((value - mean_value)^2 for value in values) / (length(values) - 1))
end

"""Growth-rate standard deviation grouped by beginning-of-period firm size."""
function growth_dispersion_by_size(previous::ModelState, current::ModelState,
                                   params::ModelParams)
    sizes = firm_sizes(previous)
    growth = firm_log_growth(previous, current, params)
    grouped = Dict{Int,Vector{Float64}}()
    for (id, rate) in growth
        push!(get!(grouped, sizes[id], Float64[]), rate)
    end
    Dict(size => sample_std(rates) for (size, rates) in grouped)
end

"""Observed firm lifetimes in reporting periods; survivors are right-censored."""
function firm_lifetimes(result::SimulationResult)
    snapshots = [result.initial_state; result.period_states]
    births = Dict{FirmId,Int}()
    completed = Dict{FirmId,Int}()
    previous = Set{FirmId}()
    for (period, state) in enumerate(snapshots)
        time = period - 1
        active = Set(firm_ids(state))
        for id in setdiff(active, previous)
            births[id] = time
        end
        for id in setdiff(previous, active)
            completed[id] = time - births[id]
            delete!(births, id)
        end
        previous = active
    end
    horizon = length(snapshots) - 1
    censored = Dict(id => horizon - birth for (id, birth) in births)
    (; completed, censored)
end
