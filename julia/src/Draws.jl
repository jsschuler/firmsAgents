"""All primitive randomness required by one deterministic update."""
struct Draw
    selected_agent::AgentId
    tie_break::UInt64
    misc::Vector{UInt64}
end

Base.:(==)(left::Draw, right::Draw) =
    left.selected_agent == right.selected_agent &&
    left.tie_break == right.tie_break && left.misc == right.misc

"""Sample a primitive draw. This is the only stochastic model boundary."""
function sample_draw(rng::AbstractRNG, state::ModelState, ::ModelConfig, params::ModelParams)
    isempty(state.agents) && throw(ArgumentError("cannot sample an agent from an empty state"))
    isempty(state.firms) && throw(ArgumentError("cannot sample a firm from an empty state"))
    agent = rand(rng, state.agents)
    Draw(agent.id, rand(rng, UInt64), UInt64[])
end
