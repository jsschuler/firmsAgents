import Mathlib

namespace AgenticAxtell.Approximation

/-- A positive number of equal subintervals in the finite effort grid. -/
structure EffortGrid where
  steps : Nat
  stepsPositive : 0 < steps

/-- Grid indices `0, ..., K` for a grid with `K` subintervals. -/
abbrev EffortLevel (grid : EffortGrid) := Fin (grid.steps + 1)

/-- Interpret a finite effort level as the real effort `level / K`. -/
noncomputable def effortValue (grid : EffortGrid) (level : EffortLevel grid) : ℝ :=
  level.val / grid.steps

theorem effortValue_nonnegative (grid : EffortGrid) (level : EffortLevel grid) :
    0 ≤ effortValue grid level := by
  exact div_nonneg (Nat.cast_nonneg level.val) (Nat.cast_nonneg grid.steps)

theorem effortValue_atMostOne (grid : EffortGrid) (level : EffortLevel grid) :
    effortValue grid level ≤ 1 := by
  apply (div_le_one (by exact_mod_cast grid.stepsPositive)).2
  exact_mod_cast (Nat.lt_succ_iff.mp level.isLt)

theorem effortValue_mem_Icc (grid : EffortGrid) (level : EffortLevel grid) :
    effortValue grid level ∈ Set.Icc (0 : ℝ) 1 :=
  ⟨effortValue_nonnegative grid level, effortValue_atMostOne grid level⟩

def zeroLevel (grid : EffortGrid) : EffortLevel grid :=
  ⟨0, Nat.zero_lt_succ grid.steps⟩

def oneLevel (grid : EffortGrid) : EffortLevel grid :=
  ⟨grid.steps, Nat.lt_succ_self grid.steps⟩

@[simp] theorem effortValue_zero (grid : EffortGrid) :
    effortValue grid (zeroLevel grid) = 0 := by
  simp [effortValue, zeroLevel]

@[simp] theorem effortValue_one (grid : EffortGrid) :
    effortValue grid (oneLevel grid) = 1 := by
  simp [effortValue, oneLevel, ne_of_gt grid.stepsPositive]

end AgenticAxtell.Approximation
