# Baseline validation status

## What is established

- Mathematical primitive tests cover production, equal sharing, utility, and
  bounded numerical best responses.
- Candidate tests enforce current-firm, neighbor-firm, and singleton-only
  search.
- `AxtellBaseCase` initializes 1,000 agents in 1,000 singleton firms with two
  fixed neighbors per agent.
- Event tests enforce fixed population, valid partitions, no empty active
  firms, deterministic replay, and exact disabled-agentic recovery.
- Diagnostic identities and monotone firm identity bookkeeping are tested.

## Preliminary smoke run

Configuration: `AxtellBaseCase`, seed `1234`, 20 reporting periods, 1,000
activations per period. This is a short implementation smoke run, not a
long-run replication exercise.

```text
elapsed_seconds          11.441
active_firms_at_period_20 329
mean_firm_size             3.0395
maximum_firm_size         94
aggregate_productivity     2.8221
matched_period-20_growth 169
completed_firm_lifetimes 2982
right-censored_lifetimes  329
state_valid              true
```

## What is not established

This run does not establish Axtell's reported scaling firm-size distribution,
Laplace growth-rate distribution, declining growth dispersion with size,
lifetime distribution, or near-constant aggregate returns. Those claims need
longer runs, multiple seeds, burn-in and sampling conventions, quantitative
comparison criteria, and sensitivity analysis for repository completion rules.

## Moderate multi-seed diagnostic

Configuration: `AxtellBaseCase`, seeds `101`, `202`, and `303`; 40 periods per
seed; first 10 periods discarded for state-distribution diagnostics. The sample
contains 120,000 activation events.

```text
ending active firms             397, 375, 365
ending maximum firm sizes        26,  30,  22
pooled firm-size observations        33,959
pooled growth observations           15,401
completed lifetime observations      16,578
rank-size log-log slope              -1.5897
growth Laplace scale                   0.7118
growth excess kurtosis                 4.1989
size-growth-dispersion log slope      -0.1290
aggregate output-effort time slope     0.2609
```

Interpretation is deliberately limited:

- Positive excess kurtosis indicates a sharply peaked/heavy-tailed growth
  distribution; a fitted Laplace distribution would have excess kurtosis 3.
- The negative size-dispersion slope agrees qualitatively with declining growth
  volatility as firms become larger.
- The rank-size slope is descriptive and is steeper than the Zipf benchmark of
  approximately `-1`; no scaling-range selection or uncertainty estimate has
  yet been applied.
- The final metric is a within-run time-series slope of log aggregate output on
  log aggregate effort. It is **not** a test of aggregate returns to scale;
  that requires a controlled population- or input-scaling experiment.

These results are promising smoke evidence for two qualitative patterns, but
they do not yet establish quantitative reproduction of the paper.

## Longer multi-seed diagnostic

Configuration: the same seeds, 80 periods per seed, first 20 discarded. This
sample contains 240,000 activation events.

```text
ending active firms                389, 368, 399
ending maximum firm sizes           48,  29,  32
pooled firm-size observations           67,844
pooled growth observations              31,559
completed lifetime observations         31,595
rank-size slope                          -1.5970
rank-size OLS standard error              0.0017
rank-size R-squared                       0.9655
rank-size tail observations              33,170
growth Laplace scale                      0.7091
growth fitted-Laplace KS distance         0.2866
growth excess kurtosis                    4.1470
size-dispersion slope                    -0.2609
size-dispersion OLS standard error        0.0718
size-dispersion R-squared                 0.2024
size groups                               54
aggregate output-effort time slope        0.1910
```

The rank-size estimate and growth kurtosis are stable relative to the shorter
run. Growth dispersion declines with size, but the low dispersion-fit
`R²` shows substantial variation around that relationship. The fitted-Laplace
KS distance is large enough that an exact Laplace description is not supported
by this diagnostic.

The OLS standard errors above treat pooled period observations as independent.
They are descriptive numerical summaries, not valid sampling uncertainty,
because firms and periods are serially dependent and observations share seeds.
Seed-clustered uncertainty or a block bootstrap is required before inferential
claims are made.

Current conclusion: the implementation produces persistent firm churn,
right-skewed firm sizes, heavy-tailed growth, and a negative relationship
between size and growth dispersion. It has **not** yet quantitatively reproduced
all reported Axtell outcome distributions.

## Independent-seed consistency experiment

Configuration: 20 independent seeds (`101:120`), 40 periods per seed, 10-period
burn-in, 800,000 activation events total. Metrics were computed within each
seed rather than inferred from one pooled regression.

```text
negative rank-size slope              20 / 20 seeds
median rank-size slope                -1.6169
rank-size slope range                 [-1.6782, -1.5298]

positive growth excess kurtosis       20 / 20 seeds
median growth excess kurtosis          4.0830
growth excess-kurtosis range          [3.0251, 6.7715]

negative size-dispersion slope        20 / 20 seeds
median size-dispersion slope          -0.1835
size-dispersion slope range           [-0.3117, -0.0706]
```

This establishes strong simulation evidence for the qualitative outcomes of
interest under the repository's semantic baseline and completion rules:

- firm sizes are consistently right-skewed with an approximately linear
  rank-size relationship on the current `size ≥ 2` range;
- firm growth is consistently much more leptokurtic than Gaussian, and in every
  seed is at least as leptokurtic as the theoretical Laplace benchmark;
- growth-rate dispersion consistently decreases with beginning-of-period firm
  size.

This evidence supports the claim that the baseline generates heavy tails. It
does not establish that either tail belongs to an exact power-law or Laplace
family. The complete seed-level results are stored in
`docs/results/axtell_20seed_40period.csv`.

## Relation to the verified finite approximation

The finite approximation now maps exact finite-horizon or stationary state
distributions to expected firm counts by size and a firm-weighted firm-size
CCDF. This supplies a direct finite analogue of the empirical rank-size tail
diagnostic, using rational arithmetic rather than sampling error.

This does not turn the observed heavy tail into a formal asymptotic theorem.
For a model with `N` agent slots, Lean proves every firm size is at most `N`
and every tail event above `N` is impossible. Heavy-tail claims therefore
remain empirical statements about the shape and persistence of the simulated
distribution as population size and observation horizon grow. The verified
finite layer establishes state-space, transition, probability, and observable
correctness for each fixed bound.

Lean additionally defines stationarity as invariance under one-step PMF
evolution and proves stationarity persists at every finite horizon. For a
specified firm identifier under any fixed-`N` state distribution, its formal
variance bound is `(N/2)^2`. Consequently an unbounded-variance statement, if
supported by future analysis, must be formulated across a sequence of models
with `N → ∞`, not for one finite simulation.

Lean proves that every nonempty finite row-stochastic real transition matrix
has a stationary probability vector, using Brouwer's theorem on the standard
simplex. The model's finite PMF kernel is proved to generate such a matrix, and
the fixed probability vector is converted back to a PMF invariant under
one-step kernel evolution. Thus every bounded finite-model kernel with a
nonempty draw space has a stationary distribution; uniqueness and convergence
still require additional chain-structure hypotheses.

## Population-scaling diagnostic

A first controlled comparison uses `N = 100, 250, 500, 1000`, five independent
seeds per population, 40 periods, and a 10-period burn-in. Each period contains
`N` activations, so simulated time is comparable across sizes. Firm-size
moments pool the 30 retained cross-sections within each independent run.

```text
population  median variance  median second moment  median maximum share  median rank slope
100                    9.47                 16.86                 0.120             -1.592
250                   12.00                 19.34                 0.072             -1.581
500                   12.56                 19.94                 0.058             -1.591
1000                  13.45                 20.00                 0.036             -1.604
```

Raw variance increases modestly across this range, while the second moment
nearly levels off and maximum firm size shrinks relative to population. The
rank-size slope is stable. These 20 finite-horizon runs therefore support
population-robust right-skew, but do **not** support an unbounded-variance
claim. Longer horizons, more independent seeds, and larger populations are
needed to distinguish slow divergence from a finite limiting second moment.
Seed-level output is in `docs/results/population_scaling_5seed_40period.csv`.

A nested horizon check at `N = 1000` uses the same five seeded trajectories at
20, 40, and 80 periods, measuring each horizon over its trailing half:

```text
horizon  median variance  median second moment  median maximum share  median rank slope
20                 15.18                 22.10                 0.034             -1.561
40                 12.23                 18.77                 0.036             -1.624
80                 16.20                 23.03                 0.048             -1.607
```

Neither variance nor the second moment grows monotonically over these horizons;
their between-seed dispersion is larger than the shift in their medians. This
weakens the hypothesis that the 40-period population comparison hid rapid
tail-moment divergence. It still cannot exclude very slow divergence. The
seed-level output is in `docs/results/horizon_scaling_5seed_n1000.csv`.

## Tail-index and truncated-moment diagnostic

Ten independent `N = 1000`, 40-period runs give the following seed-median Hill
indices and 95% percentile intervals from resampling whole seeds:

```text
upper-tail fraction  median Hill alpha  seed-bootstrap interval
5%                               2.003  [1.782, 2.327]
10%                              1.766  [1.558, 1.814]
20%                              1.413  [1.330, 1.467]
```

For a genuine Pareto survival tail, `alpha <= 2` would imply an infinite second
moment. Here the estimate changes substantially with the threshold, and the
most tail-focused interval crosses two. The data therefore do not identify a
stable Pareto exponent or justify an infinite-variance conclusion.

Median firm-weighted truncated second moments at size cutoffs 5, 10, 20, 40,
and 80 are respectively `6.48`, `10.61`, `15.15`, `19.34`, and `21.37`. They
increase with the cutoff, as they must, but the incremental increase shrinks at
the largest cutoff. This is compatible with finite-size truncation and supplies
no positive evidence of divergence. Complete seed-level results are in
`docs/results/tail_moments_10seed_n1000.csv`.

## Larger, longer run

To probe whether the preceding conclusions were artifacts of scale, three
independent trajectories were run with `N = 2000` for 200 periods (400,000
activations each), with nested trailing-half measurements:

```text
horizon  median variance  median second moment  median terminal max share  median rank slope
50                 14.06                 21.28                      0.025             -1.587
100                15.28                 22.59                      0.0215            -1.582
200                15.86                 23.14                      0.0175            -1.598
```

The second moment rises modestly rather than explosively, the rank-size slope
remains stable, and terminal maximum firm share declines. At period 200 the
three terminal maxima are 38, 33, and 35 agents. This substantially extends
both scale and duration, but three seeds and `N = 2000` still cannot settle an
asymptotic moment theorem. The result strengthens the empirical case for a
stable truncated heavy tail under this implementation and weakens—but does not
mathematically exclude—unbounded variance. Raw rows are stored in
`docs/results/long_run_3seed_n2000.csv`.

## Extreme and growing-cutoff scaling

Normalizing the maximum by population is not a test of tail breadth: a
sublinear maximum can vanish relative to `N` while diverging relative to a
stable median. A matched-seed reanalysis therefore estimates log-log scaling
across `N = 100, 250, 500, 1000` for the terminal maximum, maximum divided by
the pooled firm-size median, and second moments truncated at cutoffs that grow
with `N`.

```text
quantity                              median exponent  seed-bootstrap interval
terminal maximum                                0.668  [-0.229, 0.842]
maximum / median                                0.784  [-0.036, 1.034]
second moment, cutoff sqrt(N)                    0.217  [ 0.121, 0.385]
second moment, cutoff N^(3/4)                    0.188  [-0.132, 0.443]
second moment, cutoff N/10                       0.291  [ 0.129, 0.505]
```

The extreme-based estimates are noisy with only five seeds, but their medians
are positive. More importantly, two growing-cutoff moment intervals exclude
zero. This reverses the overly strong reading of the fixed-cutoff and
maximum-share diagnostics: there is affirmative evidence of scale-dependent
second-moment growth over the tested range. It remains insufficient to prove
that growth persists without bound, because the range spans only one decade
and cutoff conventions interact with finite samples. Raw observations and
matched-seed exponents are stored in `docs/results/extreme_scaling_5seed.csv`
and `docs/results/extreme_scaling_exponents_5seed.csv`.

The finite-sample normalized Gini coefficient gives a complementary view of
the distribution's body. It is computed separately for every retained period,
using the `m/(m-1)` correction for the period's `m` active firms, and then
averaged within each seed:

```text
population  median normalized Gini  across-seed range
100                          0.464  [0.396, 0.481]
250                          0.474  [0.437, 0.493]
500                          0.472  [0.431, 0.506]
1000                         0.469  [0.456, 0.492]
```

Normalized Gini inequality is stable near 0.47 across the measured decade.
This is compatible with simultaneous tail expansion: the Gini is dominated by
the distribution's body and is bounded by one, whereas extremes and second
moments are much more sensitive to rare large firms. Seed-level coefficients
are stored in `docs/results/normalized_gini_5seed.csv`.

## Replication stabilization of mean firm size

Thirty independent seeds were simulated at each of `N = 100, 250, 500, 1000`
for 40 periods with a 10-period burn-in. Each replication statistic first
averages mean firm size equally over retained periods; uncertainty is then
computed across independent replications. A target is called reached at the
first cumulative replication count whose approximate 95% relative half-width
is below the target and remains below it through replication 30.

```text
population  estimate at 30  relative half-width  n for 5%  n for 2%  n for 1%
100                 2.665               3.63%          21         --         --
250                 2.622               2.27%           7         --         --
500                 2.657               1.81%           5         27         --
1000                2.655               1.46%           4         20         --
```

The estimated mean is stable near 2.65 across scales, while between-seed noise
falls strongly with population. Thus large populations self-average: fewer
independent model replications are needed for a precise mean, even though tail
statistics remain much noisier. No population attains a 1% relative interval
within 30 runs. The intervals use the normal `1.96 * SE` approximation and are
a simulation-planning diagnostic, not a sequential-testing guarantee. Summary
results are in `docs/results/mean_stabilization_30rep_summary.csv`.

## Five-thousand-period drift check

A single small-population trajectory (`N = 100`, seed `20260909`) was run for
5,000 periods, totaling 500,000 activations. Log-spaced checkpoints report both
instantaneous values and trailing 100-period averages. Selected windowed
results after the initial transient are:

```text
period  mean size  variance  second moment  normalized Gini  mean maximum
100         2.960     17.34          26.33            0.494         18.72
200         2.880     16.45          24.92            0.496         19.72
500         2.847     16.39          24.75            0.485         18.80
1000        2.962     20.24          29.20            0.501         21.51
2000        2.987     22.62          31.82            0.514         22.03
5000        2.881     17.94          26.43            0.501         19.81
```

The statistics fluctuate but show no sustained drift from periods 100 through
5,000. This supports approximate time stability at `N = 100` and shows that
the earlier 40-period sampling was not simply preceding a large slow temporal
trend at this scale. One trajectory cannot establish stationarity or describe
rare-event uncertainty. Full checkpoint data are stored in
`docs/results/long_time_drift_n100_seed20260909.csv`.

The first exact economic example uses two mutually neighboring agents, two
initial singleton firms, a three-level effort grid, and the baseline nonlinear
utility. Its reachable transition matrix is
`[[0,1/2,1/2],[0,1,0],[0,0,1]]`. The first selected agent determines which firm
absorbs the other, so the two consolidated states are distinct absorbing
classes. Starting from the separated state, the limiting distribution is the
equal mixture of those classes. This demonstrates concretely why stationary
existence alone does not imply uniqueness, even though the firm-size outcome
is identical—one firm of size two—in both terminal states.

With three mutually neighboring homogeneous agents, exact enumeration yields
85 reachable states, 55 communicating classes, and 12 singleton absorbing
classes. Rational absorption probabilities are obtained by solving the finite
Dirichlet equations and sum exactly to one. All 12 absorbing states nevertheless
have the same unlabeled firm-size composition `[3]`. Thus stationary
nonuniqueness at this scale concerns labels and effort histories, not the
firm-size observable; a larger or less symmetric network is needed for
competing terminal size compositions.
