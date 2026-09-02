module AgenticAxtell

using Random: AbstractRNG, Xoshiro, rand

include("Config.jl")
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
       ModelParams, axtell_base_case, AgentId, FirmId, AgentState, FirmState, ModelState,
       Draw, valid, sample_draw, firm_ids, firm_members, firm_effort,
       production, firm_output, income, utility, candidate_firms,
       optimal_effort, initialize, baseline_transition, step, trajectory,
       SimulationMetadata, SimulationResult, simulate,
       firm_sizes, firm_outputs, aggregate_output, aggregate_productivity,
       effort_distribution, income_distribution, utility_distribution,
       firm_log_growth, growth_dispersion_by_size, firm_lifetimes,
       ValidationConfig, ValidationSummary, validate_baseline,
       AbstractExtensionOperator, ComputeOperator, SpawnOperator,
       TerminationOperator, DelegationOperator, SpecializationOperator,
       HierarchyOperator, ComputeMarketOperator, ComputeInheritanceOperator,
       AgentMutationOperator, apply_extension

end
