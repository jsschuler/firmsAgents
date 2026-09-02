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
