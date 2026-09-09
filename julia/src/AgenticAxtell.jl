module AgenticAxtell

using Random: AbstractRNG, Xoshiro, rand

include("Config.jl")
include("Approximation.jl")
include("Params.jl")
include("State.jl")
include("Draws.jl")
include("Production.jl")
include("Utility.jl")
include("Candidates.jl")
include("BestResponse.jl")
include("Initialization.jl")
include("Baseline.jl")
include("Extensions.jl")
include("Transition.jl")
include("Simulation.jl")
include("Diagnostics.jl")
include("Validation.jl")

export ModelConfig, baseline_config, all_extensions_enabled,
       AbstractEffortDomain, ContinuousEffort, EffortGrid, EffortLevel,
       effort_levels, effort_value,
       FiniteModelBounds, FiniteAgentId, FiniteFirmId, FiniteAgentState,
       FiniteModelState, FiniteAction, FiniteDraw, agent_ids,
       finite_draws, is_candidate_firm, finite_valid, finite_graph_valid, finite_transition,
       finite_transition_matrix,
       finite_distribution_after, is_stationary_distribution,
       finite_firm_sizes, finite_expected_size_counts, finite_size_ccdf,
       finite_transition_adjacency, finite_reachability,
       finite_communicating_classes, finite_closed_classes,
       finite_absorbing_states, finite_irreducible, finite_class_periods,
       finite_aperiodic, finite_closed_class_absorption,
       FiniteBestResponseRule, finite_candidate_firms, finite_reachable_states,
       ModelParams, axtell_base_case, AgentId, FirmId, AgentState, FirmState, ModelState,
       Draw, valid, sample_draw, firm_ids, firm_members, firm_effort,
       production, firm_output, income, utility, candidate_firms,
       optimal_effort, initialize, baseline_transition, step, trajectory,
       SimulationMetadata, SimulationResult, simulate,
       firm_sizes, normalized_gini, firm_outputs, aggregate_output, aggregate_productivity,
       effort_distribution, income_distribution, utility_distribution,
       firm_log_growth, growth_dispersion_by_size, firm_lifetimes,
       ValidationConfig, ValidationSummary, validate_baseline,
       AbstractExtensionOperator, ComputeOperator, SpawnOperator,
       TerminationOperator, DelegationOperator, SpecializationOperator,
       HierarchyOperator, ComputeMarketOperator, ComputeInheritanceOperator,
       AgentMutationOperator, apply_extension

end
