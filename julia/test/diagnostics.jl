@testset "period simulation and metadata" begin
    params = ModelParams(n_max=30, neighbors_per_agent=2, activations_per_period=30)
    result1 = simulate(20260902, params; periods=5)
    result2 = simulate(20260902, params; periods=5)
    @test result1.metadata.seed == UInt64(20260902)
    @test result1.metadata.periods == 5
    @test length(result1.draws) == 150
    @test result1.initial_state == result2.initial_state
    @test result1.period_states == result2.period_states
    @test result1.draws == result2.draws
    @test trajectory(result1.initial_state, result1.draws, baseline_config(), params)[end] ==
          result1.period_states[end]
    @test all(state -> valid(state, params), result1.period_states)
end


@testset "multi-seed validation metrics" begin
    params = ModelParams(n_max=24, neighbors_per_agent=2, activations_per_period=24)
    config = ValidationConfig(seeds=UInt64[3, 5], periods=6, burn_in=2)
    summary1 = validate_baseline(params; config)
    summary2 = validate_baseline(params; config)
    @test summary1.ending_firm_counts == summary2.ending_firm_counts
    @test summary1.ending_max_sizes == summary2.ending_max_sizes
    @test summary1.pooled_firm_sizes == summary2.pooled_firm_sizes
    @test summary1.pooled_growth_rates == summary2.pooled_growth_rates
    @test length(summary1.ending_firm_counts) == 2
    @test !isempty(summary1.pooled_firm_sizes)
    @test all(>(0), summary1.pooled_firm_sizes)
    @test isfinite(summary1.rank_size_slope)
    @test summary1.rank_size_tail_count > 0
    @test 0.0 <= summary1.rank_size_r_squared <= 1.0
    @test 0.0 <= summary1.growth_laplace_ks <= 1.0
    @test summary1.size_dispersion_group_count >= 0
end


@testset "AxtellBaseCase one-period smoke" begin
    params = axtell_base_case()
    result = simulate(1234, params; periods=1)
    state = only(result.period_states)
    @test length(result.draws) == 1000
    @test length(state.agents) == 1000
    @test valid(state, params)
    @test sum(values(firm_sizes(state))) == 1000
end

@testset "diagnostic identities" begin
    params = ModelParams(n_max=30, neighbors_per_agent=2, activations_per_period=30)
    result = simulate(19, params; periods=4)
    state = result.period_states[end]
    sizes = firm_sizes(state)
    outputs = firm_outputs(state, params)
    @test sum(values(sizes)) == params.n_max
    @test sum(values(outputs)) ≈ aggregate_output(state, params)
    @test length(effort_distribution(state)) == params.n_max
    @test length(income_distribution(state, params)) == params.n_max
    @test length(utility_distribution(state, params)) == params.n_max
    @test all(isfinite, income_distribution(state, params))
    @test isfinite(aggregate_productivity(state, params))

    growth = firm_log_growth(result.period_states[end - 1], state, params)
    dispersion = growth_dispersion_by_size(result.period_states[end - 1], state, params)
    @test all(isfinite, values(growth))
    @test all(value -> isfinite(value) && value >= 0.0, values(dispersion))
    lifetimes = firm_lifetimes(result)
    @test all(>=(0), values(lifetimes.completed))
    @test all(>=(0), values(lifetimes.censored))
end
