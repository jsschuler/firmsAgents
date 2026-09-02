abstract type AbstractExtensionOperator end
struct ComputeOperator <: AbstractExtensionOperator end
struct SpawnOperator <: AbstractExtensionOperator end
struct TerminationOperator <: AbstractExtensionOperator end
struct DelegationOperator <: AbstractExtensionOperator end
struct SpecializationOperator <: AbstractExtensionOperator end
struct HierarchyOperator <: AbstractExtensionOperator end
struct ComputeMarketOperator <: AbstractExtensionOperator end
struct ComputeInheritanceOperator <: AbstractExtensionOperator end
struct AgentMutationOperator <: AbstractExtensionOperator end

"""A disabled extension is definitionally an identity through dispatch."""
apply_extension(::AbstractExtensionOperator, ::Val{false}, state::ModelState, ::Draw, ::ModelParams) = state

"""Enabled milestone placeholders remain inert until their milestone is active."""
function apply_extension(operator::AbstractExtensionOperator, ::Val{true}, state::ModelState, ::Draw, ::ModelParams)
    # TODO(extensions): add behavior in the operator's designated milestone.
    state
end

