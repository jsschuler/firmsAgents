# Implementation completion rules

The normative baseline is `SPEC_ADDENDUM_AXTELL.md`. The source description
does not uniquely determine every computational detail. These rules are
repository completion rules and are **not attributed to Axtell**.

- Julia maximizes effort by deterministic golden-section search on `[0,1]`,
  checking both endpoints. `optimization_tolerance` controls stopping.
- Alternatives within `utility_tolerance` of the maximum are tied;
  `Draw.tie_break` selects modulo the tie count.
- Candidate order is current firm, distinct neighbor firms in neighbor-list
  order, then singleton startup.
- `AxtellBaseCase` initializes every effort to `0.5`.
- Fixed directed neighbors are sampled without replacement; symmetry is not
  imposed.
- Initial firm IDs equal agent IDs. A monotone counter assigns every startup a
  never-reused firm ID, which makes births, deaths, and lifetimes unambiguous.
- Alternatives use the pre-event state and the membership/effort update is
  atomic. The activated agent is excluded from current-firm `E_{-i}`.
- Julia uses `Float64`; Lean specifies the continuous skeleton over `ℝ`.
  Historical bitwise replication is not claimed.

## Lean maximizer selection

Lean proves existence of an optimal effort for every candidate firm and an
optimal choice across the finite local candidate set. It now constructs a
noncomputable draw-indexed semantic rule: `Draw.tieBreak` selects modulo the
nonempty finite set of exactly maximizing firms, and the selected choice
satisfies every `ChoiceRule` obligation. The older canonical rule remains as a
useful existence witness.

This does not claim bit-for-bit tie equivalence with Julia. Lean uses exact real
maximizers and `Finset.toList` enumeration, whereas Julia groups numerically
optimized alternatives within `utility_tolerance` and preserves candidate-list
order. Thus the formal result captures draw-indexed selection among true
maximizers; numerical near-ties and enumeration order remain implementation
completion details. They do not affect the generic validity or semantic
recovery theorems.

## Validation statistics

- Firm growth is adjacent-period log output growth for firm IDs active in both
  snapshots. Entry and exit are handled by lifetime statistics, not assigned
  artificial growth rates.
- Rank-size regression pools post-burn-in firm-period observations with size at
  least two. No data-driven scaling-range selection is currently performed.
- Laplace location is the sample median and scale is mean absolute deviation
  from that median. The reported KS distance uses those fitted parameters.
- Size-dependent dispersion pools growth by beginning-of-period employment and
  retains sizes with at least three observations and positive sample variance.
- Pooled OLS standard errors are descriptive only because observations are
  serially dependent and clustered within simulation seeds.
