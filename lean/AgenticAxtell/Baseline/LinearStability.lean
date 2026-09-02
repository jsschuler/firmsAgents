import AgenticAxtell.Baseline.LinearBestResponse

namespace AgenticAxtell.Baseline

/-- Jacobian of the simultaneous linear-production response on a region where
every response is strictly above its zero floor. -/
def linearResponseJacobian {groupSize : Nat} (theta : Fin groupSize → ℝ) :
    Matrix (Fin groupSize) (Fin groupSize) ℝ :=
  fun row column => if row = column then 0 else -(1 - theta row)

/-- The affine response before applying the zero-effort floor. -/
def interiorLinearResponse {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (profile : FixedGroupProfile groupSize) : FixedGroupProfile groupSize :=
  fun agent => theta agent - (1 - theta agent) * fixedGroupOtherEffort profile agent

theorem linearResponse_eq_interior_of_positive {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (profile : FixedGroupProfile groupSize)
    (positive : ∀ agent, 0 < linearFixedGroupResponse theta profile agent) :
    linearFixedGroupResponse theta profile = interiorLinearResponse theta profile := by
  funext agent
  unfold linearFixedGroupResponse linearBestResponseCandidate interiorLinearResponse
  exact max_eq_right (le_of_lt (by
    simpa [linearFixedGroupResponse, linearBestResponseCandidate] using positive agent))

@[simp] theorem linearResponseJacobian_diagonal {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (agent : Fin groupSize) :
    linearResponseJacobian theta agent agent = 0 := by
  simp [linearResponseJacobian]

theorem linearResponseJacobian_offDiagonal {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (row column : Fin groupSize) (distinct : row ≠ column) :
    linearResponseJacobian theta row column = -(1 - theta row) := by
  simp [linearResponseJacobian, distinct]

theorem linearResponseJacobian_offDiagonal_nonpositive {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaAtMostOne : ∀ agent, theta agent ≤ 1)
    (row column : Fin groupSize) (distinct : row ≠ column) :
    linearResponseJacobian theta row column ≤ 0 := by
  rw [linearResponseJacobian_offDiagonal theta row column distinct]
  exact neg_nonpos.mpr (sub_nonneg.mpr (thetaAtMostOne row))

theorem linearResponseJacobian_mulVec_apply {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (vector : Fin groupSize → ℝ) (row : Fin groupSize) :
    (linearResponseJacobian theta).mulVec vector row =
      -(1 - theta row) * (∑ column, vector column - vector row) := by
  simp only [Matrix.mulVec, dotProduct, linearResponseJacobian]
  have filteredSum :
      (∑ column, (if row = column then 0 else -(1 - theta row)) * vector column) =
        ∑ column ∈ Finset.univ.filter (· ≠ row),
          -(1 - theta row) * vector column := by
    rw [Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro column _
    by_cases distinct : column ≠ row
    · have reverseDistinct : row ≠ column := Ne.symm distinct
      simp [distinct, reverseDistinct]
    · have equal : column = row := not_ne_iff.mp distinct
      subst column
      simp
  rw [filteredSum, ← Finset.mul_sum]
  have eraseIdentity :
      ∑ column ∈ Finset.univ.filter (· ≠ row), vector column =
        (∑ column, vector column) - vector row := by
    have filterEq : Finset.univ.filter (· ≠ row) = Finset.univ.erase row := by
      ext column
      simp [eq_comm]
    rw [filterEq]
    have totalIdentity :
        (∑ column ∈ Finset.univ.erase row, vector column) + vector row =
          ∑ column, vector column :=
      Finset.sum_erase_add Finset.univ vector (Finset.mem_univ row)
    linarith
  rw [eraseIdentity]

/-- A discrete-time linearization is unstable when it has a nonzero real
eigenvector whose eigenvalue has modulus greater than one. -/
def IsLinearlyUnstable {groupSize : Nat}
    (jacobian : Matrix (Fin groupSize) (Fin groupSize) ℝ) : Prop :=
  ∃ vector : Fin groupSize → ℝ, ∃ eigenvalue : ℝ,
    vector ≠ 0 ∧ jacobian.mulVec vector = eigenvalue • vector ∧ 1 < |eigenvalue|

def IsRealEigenpair {groupSize : Nat}
    (jacobian : Matrix (Fin groupSize) (Fin groupSize) ℝ)
    (eigenvalue : ℝ) (vector : Fin groupSize → ℝ) : Prop :=
  vector ≠ 0 ∧ jacobian.mulVec vector = eigenvalue • vector

theorem heterogeneousEigenpair_coordinate {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (eigenvalue : ℝ)
    (vector : Fin groupSize → ℝ)
    (eigenpair : IsRealEigenpair (linearResponseJacobian theta) eigenvalue vector)
    (row : Fin groupSize) :
    (eigenvalue - (1 - theta row)) * vector row =
      -(1 - theta row) * ∑ column, vector column := by
  have coordinate := congrFun eigenpair.2 row
  rw [linearResponseJacobian_mulVec_apply] at coordinate
  simp only [Pi.smul_apply, smul_eq_mul] at coordinate
  linarith

theorem heterogeneousEigenpair_zeroSum_mode {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (eigenvalue : ℝ)
    (vector : Fin groupSize → ℝ)
    (eigenpair : IsRealEigenpair (linearResponseJacobian theta) eigenvalue vector)
    (zeroSum : ∑ column, vector column = 0) (row : Fin groupSize) :
    (eigenvalue - (1 - theta row)) * vector row = 0 := by
  rw [heterogeneousEigenpair_coordinate theta eigenvalue vector eigenpair row, zeroSum,
    mul_zero]

theorem heterogeneousEigenpair_zeroSum_nonzero_coordinate {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (eigenvalue : ℝ)
    (vector : Fin groupSize → ℝ)
    (eigenpair : IsRealEigenpair (linearResponseJacobian theta) eigenvalue vector)
    (zeroSum : ∑ column, vector column = 0) (row : Fin groupSize)
    (coordinateNonzero : vector row ≠ 0) :
    eigenvalue = 1 - theta row := by
  have productZero := heterogeneousEigenpair_zeroSum_mode theta eigenvalue vector
    eigenpair zeroSum row
  rcases mul_eq_zero.mp productZero with differenceZero | coordinateZero
  · exact sub_eq_zero.mp differenceZero
  · exact (coordinateNonzero coordinateZero).elim

theorem heterogeneousEigenpair_secularEquation {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (eigenvalue : ℝ)
    (vector : Fin groupSize → ℝ)
    (eigenpair : IsRealEigenpair (linearResponseJacobian theta) eigenvalue vector)
    (aggregateNonzero : (∑ column, vector column) ≠ 0)
    (awayFromPoles : ∀ row, eigenvalue - (1 - theta row) ≠ 0) :
    ∑ row, (-(1 - theta row)) / (eigenvalue - (1 - theta row)) = 1 := by
  let aggregate := ∑ column, vector column
  have coordinateFormula : ∀ row,
      vector row = (-(1 - theta row) / (eigenvalue - (1 - theta row))) * aggregate := by
    intro row
    have coordinate := heterogeneousEigenpair_coordinate theta eigenvalue vector eigenpair row
    rw [div_mul_eq_mul_div]
    apply (eq_div_iff (awayFromPoles row)).2
    dsimp [aggregate]
    nlinarith
  have summed := congrArg (fun profile : Fin groupSize → ℝ => ∑ row, profile row)
    (funext coordinateFormula)
  change aggregate =
    ∑ row, (-(1 - theta row) / (eigenvalue - (1 - theta row))) * aggregate at summed
  rw [← Finset.sum_mul] at summed
  have productEquality :
      (∑ row, (-(1 - theta row)) / (eigenvalue - (1 - theta row))) * aggregate =
        1 * aggregate := by
    rw [one_mul]
    exact summed.symm
  exact mul_right_cancel₀ aggregateNonzero productEquality

theorem heterogeneousEigenpair_of_secularEquation {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (eigenvalue : ℝ)
    (awayFromPoles : ∀ row, eigenvalue - (1 - theta row) ≠ 0)
    (secular : ∑ row, (-(1 - theta row)) / (eigenvalue - (1 - theta row)) = 1) :
    ∃ vector, IsRealEigenpair (linearResponseJacobian theta) eigenvalue vector ∧
      ∑ row, vector row = 1 := by
  let vector : Fin groupSize → ℝ := fun row =>
    (-(1 - theta row)) / (eigenvalue - (1 - theta row))
  have vectorSum : ∑ row, vector row = 1 := by
    simpa [vector] using secular
  have vectorNonzero : vector ≠ 0 := by
    intro vectorZero
    have zeroSum : ∑ row, vector row = 0 := by simp [vectorZero]
    linarith
  refine ⟨vector, ⟨vectorNonzero, ?_⟩, vectorSum⟩
  funext row
  rw [linearResponseJacobian_mulVec_apply]
  simp only [Pi.smul_apply, smul_eq_mul, vectorSum]
  dsimp [vector]
  have denominatorNonzero := awayFromPoles row
  field_simp
  ring

noncomputable def heterogeneousSecularFunction {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (eigenvalue : ℝ) : ℝ :=
  ∑ row, (-(1 - theta row)) / (eigenvalue - (1 - theta row))

theorem heterogeneousSecularFunction_continuousOn_negative {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaAtMostOne : ∀ row, theta row ≤ 1) :
    ContinuousOn (heterogeneousSecularFunction theta) (Set.Iio 0) := by
  unfold heterogeneousSecularFunction
  apply continuousOn_finset_sum
  intro row _
  apply ContinuousOn.div continuousOn_const (continuousOn_id.sub continuousOn_const)
  intro eigenvalue eigenvalueNegative
  change eigenvalue < 0 at eigenvalueNegative
  have coefficientNonnegative : 0 ≤ 1 - theta row :=
    sub_nonneg.mpr (thetaAtMostOne row)
  change eigenvalue - (1 - theta row) ≠ 0
  linarith

theorem exists_negative_secularRoot_of_crossing {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaAtMostOne : ∀ row, theta row ≤ 1)
    (lower upper : ℝ) (lowerLeUpper : lower ≤ upper) (upperNegative : upper < 0)
    (lowerValue : heterogeneousSecularFunction theta lower ≤ 1)
    (upperValue : 1 ≤ heterogeneousSecularFunction theta upper) :
    ∃ eigenvalue ∈ Set.Icc lower upper,
      eigenvalue < 0 ∧ heterogeneousSecularFunction theta eigenvalue = 1 := by
  have intervalSubset : Set.Icc lower upper ⊆ Set.Iio (0 : ℝ) := by
    intro value valueMem
    exact lt_of_le_of_lt valueMem.2 upperNegative
  have continuousOnInterval :=
    (heterogeneousSecularFunction_continuousOn_negative theta thetaAtMostOne).mono
      intervalSubset
  have targetMem : (1 : ℝ) ∈ Set.Icc
      (heterogeneousSecularFunction theta lower)
      (heterogeneousSecularFunction theta upper) := ⟨lowerValue, upperValue⟩
  obtain ⟨eigenvalue, eigenvalueMem, root⟩ :=
    intermediate_value_Icc lowerLeUpper continuousOnInterval targetMem
  exact ⟨eigenvalue, eigenvalueMem,
    lt_of_le_of_lt eigenvalueMem.2 upperNegative, root⟩

theorem heterogeneousSecularFunction_at_neg_coefficientSum_le_one
    {groupSize : Nat} (theta : Fin groupSize → ℝ)
    (thetaAtMostOne : ∀ row, theta row ≤ 1)
    (coefficientSumPositive : 0 < ∑ row, (1 - theta row)) :
    heterogeneousSecularFunction theta (-(∑ row, (1 - theta row))) ≤ 1 := by
  let coefficientSum : ℝ := ∑ row, (1 - theta row)
  have eachBound : ∀ row,
      (-(1 - theta row)) / (-coefficientSum - (1 - theta row)) ≤
        (1 - theta row) / coefficientSum := by
    intro row
    have coefficientNonnegative : 0 ≤ 1 - theta row :=
      sub_nonneg.mpr (thetaAtMostOne row)
    have denominatorPositive : 0 < coefficientSum + (1 - theta row) := by
      dsimp [coefficientSum]
      linarith
    have fractionEq :
        (-(1 - theta row)) / (-coefficientSum - (1 - theta row)) =
          (1 - theta row) / (coefficientSum + (1 - theta row)) := by
      have originalDenominatorNonzero :
          -coefficientSum - (1 - theta row) ≠ 0 := by linarith
      field_simp [ne_of_gt denominatorPositive, originalDenominatorNonzero]
      ring
    rw [fractionEq]
    apply (div_le_div_iff₀ denominatorPositive coefficientSumPositive).2
    nlinarith
  unfold heterogeneousSecularFunction
  change (∑ row, (-(1 - theta row)) / (-coefficientSum - (1 - theta row))) ≤ 1
  calc
    (∑ row, (-(1 - theta row)) / (-coefficientSum - (1 - theta row))) ≤
        ∑ row, (1 - theta row) / coefficientSum :=
      Finset.sum_le_sum fun row _ => eachBound row
    _ = 1 := by
      rw [← Finset.sum_div]
      dsimp [coefficientSum]
      exact div_self (ne_of_gt coefficientSumPositive)

theorem exists_negative_secularRoot_of_threshold {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaAtMostOne : ∀ row, theta row ≤ 1)
    (threshold : 1 < ∑ row, (1 - theta row) / (1 + (1 - theta row))) :
    ∃ eigenvalue < 0, heterogeneousSecularFunction theta eigenvalue = 1 := by
  let coefficientSum : ℝ := ∑ row, (1 - theta row)
  have termBound : ∀ row,
      (1 - theta row) / (1 + (1 - theta row)) ≤ 1 - theta row := by
    intro row
    have coefficientNonnegative : 0 ≤ 1 - theta row :=
      sub_nonneg.mpr (thetaAtMostOne row)
    have denominatorPositive : 0 < 1 + (1 - theta row) := by linarith
    apply (div_le_iff₀ denominatorPositive).2
    nlinarith
  have coefficientSumAboveOne : 1 < coefficientSum := by
    have sumBound :
        (∑ row, (1 - theta row) / (1 + (1 - theta row))) ≤ coefficientSum := by
      dsimp [coefficientSum]
      exact Finset.sum_le_sum fun row _ => termBound row
    linarith
  have upperValue : 1 ≤ heterogeneousSecularFunction theta (-1) := by
    have valueEq : heterogeneousSecularFunction theta (-1) =
        ∑ row, (1 - theta row) / (1 + (1 - theta row)) := by
      unfold heterogeneousSecularFunction
      apply Finset.sum_congr rfl
      intro row _
      have denominatorPositive : 0 < 1 + (1 - theta row) := by
        have := sub_nonneg.mpr (thetaAtMostOne row)
        linarith
      have originalDenominatorNonzero : -1 - (1 - theta row) ≠ 0 := by
        linarith
      field_simp [ne_of_gt denominatorPositive, originalDenominatorNonzero]
      ring
    rw [valueEq]
    exact threshold.le
  have lowerValue : heterogeneousSecularFunction theta (-coefficientSum) ≤ 1 := by
    apply heterogeneousSecularFunction_at_neg_coefficientSum_le_one theta thetaAtMostOne
    linarith
  obtain ⟨eigenvalue, _, eigenvalueNegative, root⟩ :=
    exists_negative_secularRoot_of_crossing theta thetaAtMostOne
      (-coefficientSum) (-1) (by linarith) (by norm_num) lowerValue upperValue
  exact ⟨eigenvalue, eigenvalueNegative, root⟩

theorem aggregateEigenvalue_le_coefficientBound {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (eigenvalue coefficientBound : ℝ)
    (vector : Fin groupSize → ℝ)
    (eigenpair : IsRealEigenpair (linearResponseJacobian theta) eigenvalue vector)
    (aggregateNonzero : (∑ column, vector column) ≠ 0)
    (thetaAtMostOne : ∀ row, theta row ≤ 1)
    (coefficientsBounded : ∀ row, 1 - theta row ≤ coefficientBound)
    (awayFromPoles : ∀ row, eigenvalue - (1 - theta row) ≠ 0) :
    eigenvalue ≤ coefficientBound := by
  by_contra aboveBound
  have eigenvalueAbove : coefficientBound < eigenvalue := lt_of_not_ge aboveBound
  have eachNonpositive : ∀ row,
      (-(1 - theta row)) / (eigenvalue - (1 - theta row)) ≤ 0 := by
    intro row
    exact div_nonpos_of_nonpos_of_nonneg
      (neg_nonpos.mpr (sub_nonneg.mpr (thetaAtMostOne row)))
      (sub_nonneg.mpr (le_trans (coefficientsBounded row) eigenvalueAbove.le))
  have sumNonpositive :
      ∑ row, (-(1 - theta row)) / (eigenvalue - (1 - theta row)) ≤ 0 :=
    Finset.sum_nonpos fun row _ => eachNonpositive row
  rw [heterogeneousEigenpair_secularEquation theta eigenvalue vector eigenpair
    aggregateNonzero awayFromPoles] at sumNonpositive
  linarith

theorem negativeAggregateEigenvalue_lt_negOne_of_threshold {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (eigenvalue : ℝ)
    (vector : Fin groupSize → ℝ)
    (eigenpair : IsRealEigenpair (linearResponseJacobian theta) eigenvalue vector)
    (aggregateNonzero : (∑ column, vector column) ≠ 0)
    (thetaAtMostOne : ∀ row, theta row ≤ 1) (eigenvalueNegative : eigenvalue < 0)
    (threshold : 1 < ∑ row, (1 - theta row) / (1 + (1 - theta row))) :
    eigenvalue < -1 := by
  have coefficientsNonnegative : ∀ row, 0 ≤ 1 - theta row :=
    fun row => sub_nonneg.mpr (thetaAtMostOne row)
  have awayFromPoles : ∀ row, eigenvalue - (1 - theta row) ≠ 0 := by
    intro row equality
    have : eigenvalue = 1 - theta row := sub_eq_zero.mp equality
    linarith [coefficientsNonnegative row]
  have secular := heterogeneousEigenpair_secularEquation theta eigenvalue vector eigenpair
    aggregateNonzero awayFromPoles
  by_contra notBelow
  have negOneLe : -1 ≤ eigenvalue := le_of_not_gt notBelow
  have termComparison : ∀ row,
      (1 - theta row) / (1 + (1 - theta row)) ≤
        (-(1 - theta row)) / (eigenvalue - (1 - theta row)) := by
    intro row
    have coefficientNonnegative := coefficientsNonnegative row
    have leftDenominatorPositive : 0 < 1 + (1 - theta row) := by linarith
    have rightDenominatorNegative : eigenvalue - (1 - theta row) < 0 := by
      linarith
    by_cases coefficientZero : 1 - theta row = 0
    · simp [coefficientZero]
    have coefficientPositive : 0 < 1 - theta row :=
      lt_of_le_of_ne coefficientNonnegative (Ne.symm coefficientZero)
    rw [neg_div, ← div_neg]
    have denominatorOrder : -(eigenvalue - (1 - theta row)) ≤
        1 + (1 - theta row) := by linarith
    exact (div_le_div_iff_of_pos_left
      coefficientPositive
      leftDenominatorPositive (neg_pos.mpr rightDenominatorNegative)).2 denominatorOrder
  have sumComparison :
      (∑ row, (1 - theta row) / (1 + (1 - theta row))) ≤
        ∑ row, (-(1 - theta row)) / (eigenvalue - (1 - theta row)) :=
    Finset.sum_le_sum fun row _ => termComparison row
  rw [secular] at sumComparison
  exact (not_lt_of_ge sumComparison) threshold

theorem heterogeneousLinearResponse_unstable_of_negativeAggregateMode
    {groupSize : Nat} (theta : Fin groupSize → ℝ) (eigenvalue : ℝ)
    (vector : Fin groupSize → ℝ)
    (eigenpair : IsRealEigenpair (linearResponseJacobian theta) eigenvalue vector)
    (aggregateNonzero : (∑ column, vector column) ≠ 0)
    (thetaAtMostOne : ∀ row, theta row ≤ 1) (eigenvalueNegative : eigenvalue < 0)
    (threshold : 1 < ∑ row, (1 - theta row) / (1 + (1 - theta row))) :
    IsLinearlyUnstable (linearResponseJacobian theta) := by
  have eigenvalueBelow := negativeAggregateEigenvalue_lt_negOne_of_threshold theta
    eigenvalue vector eigenpair aggregateNonzero thetaAtMostOne eigenvalueNegative threshold
  refine ⟨vector, eigenvalue, eigenpair.1, eigenpair.2, ?_⟩
  rw [abs_of_neg eigenvalueNegative]
  linarith

theorem heterogeneousLinearResponse_unstable_of_negativeSecularRoot
    {groupSize : Nat} (theta : Fin groupSize → ℝ) (eigenvalue : ℝ)
    (thetaAtMostOne : ∀ row, theta row ≤ 1) (eigenvalueNegative : eigenvalue < 0)
    (awayFromPoles : ∀ row, eigenvalue - (1 - theta row) ≠ 0)
    (secular : ∑ row, (-(1 - theta row)) / (eigenvalue - (1 - theta row)) = 1)
    (threshold : 1 < ∑ row, (1 - theta row) / (1 + (1 - theta row))) :
    IsLinearlyUnstable (linearResponseJacobian theta) := by
  obtain ⟨vector, eigenpair, vectorSum⟩ :=
    heterogeneousEigenpair_of_secularEquation theta eigenvalue awayFromPoles secular
  apply heterogeneousLinearResponse_unstable_of_negativeAggregateMode theta eigenvalue
    vector eigenpair
  · rw [vectorSum]
    norm_num
  · exact thetaAtMostOne
  · exact eigenvalueNegative
  · exact threshold

theorem heterogeneousLinearResponse_unstable_of_threshold {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (thetaAtMostOne : ∀ row, theta row ≤ 1)
    (threshold : 1 < ∑ row, (1 - theta row) / (1 + (1 - theta row))) :
    IsLinearlyUnstable (linearResponseJacobian theta) := by
  obtain ⟨eigenvalue, eigenvalueNegative, root⟩ :=
    exists_negative_secularRoot_of_threshold theta thetaAtMostOne threshold
  have awayFromPoles : ∀ row, eigenvalue - (1 - theta row) ≠ 0 := by
    intro row equality
    have coefficientNonnegative : 0 ≤ 1 - theta row :=
      sub_nonneg.mpr (thetaAtMostOne row)
    have eigenvalueEq : eigenvalue = 1 - theta row := sub_eq_zero.mp equality
    linarith
  apply heterogeneousLinearResponse_unstable_of_negativeSecularRoot theta eigenvalue
    thetaAtMostOne eigenvalueNegative awayFromPoles
  · simpa [heterogeneousSecularFunction] using root
  · exact threshold

theorem homogeneousJacobian_mulVec_one (theta : ℝ) (groupSize : Nat) :
    (linearResponseJacobian (fun _ : Fin groupSize => theta)).mulVec
        (fun _ : Fin groupSize => (1 : ℝ)) =
      (-(1 - theta) * (groupSize - 1 : Nat)) •
        (fun _ : Fin groupSize => (1 : ℝ)) := by
  funext row
  simp only [Matrix.mulVec, dotProduct, linearResponseJacobian, Pi.smul_apply,
    smul_eq_mul, mul_one]
  have filterEq : Finset.univ.filter (· ≠ row) = Finset.univ.erase row := by
    ext column
    simp [eq_comm]
  calc
    (∑ column, if row = column then 0 else -(1 - theta)) =
        ∑ column ∈ Finset.univ.filter (· ≠ row), -(1 - theta) := by
      rw [Finset.sum_filter]
      apply Finset.sum_congr rfl
      intro column _
      by_cases distinct : column ≠ row
      · have reverseDistinct : row ≠ column := Ne.symm distinct
        simp [distinct, reverseDistinct]
      · have equal : column = row := not_ne_iff.mp distinct
        subst column
        simp
    _ = -(1 - theta) * (groupSize - 1 : Nat) := by
      rw [filterEq, Finset.sum_const,
        Finset.card_erase_of_mem (Finset.mem_univ row)]
      simp
      ring

theorem interiorLinearResponse_add_sub (theta : Fin groupSize → ℝ)
    (profile perturbation : FixedGroupProfile groupSize) :
    interiorLinearResponse theta (profile + perturbation) -
        interiorLinearResponse theta profile =
      (linearResponseJacobian theta).mulVec perturbation := by
  funext row
  simp only [Pi.sub_apply, Pi.add_apply, interiorLinearResponse,
    fixedGroupOtherEffort, Matrix.mulVec, dotProduct, linearResponseJacobian]
  have filterEq : Finset.univ.filter (· ≠ row) = Finset.univ.erase row := by
    ext column
    simp [eq_comm]
  have jacobianSum :
      (∑ column, if row = column then 0 else -(1 - theta row) * perturbation column) =
        ∑ column ∈ Finset.univ.filter (· ≠ row),
          -(1 - theta row) * perturbation column := by
    rw [Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro column _
    by_cases distinct : column ≠ row
    · have reverseDistinct : row ≠ column := Ne.symm distinct
      simp [distinct, reverseDistinct]
    · have equal : column = row := not_ne_iff.mp distinct
      subst column
      simp
  simp_rw [ite_mul, zero_mul]
  rw [jacobianSum]
  rw [Finset.sum_add_distrib]
  rw [← Finset.mul_sum]
  ring

theorem clampedResponse_increment_eq_jacobian_mulVec {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (profile perturbation : FixedGroupProfile groupSize)
    (profilePositive : ∀ agent, 0 < linearFixedGroupResponse theta profile agent)
    (perturbedPositive : ∀ agent,
      0 < linearFixedGroupResponse theta (profile + perturbation) agent) :
    linearFixedGroupResponse theta (profile + perturbation) -
        linearFixedGroupResponse theta profile =
      (linearResponseJacobian theta).mulVec perturbation := by
  rw [linearResponse_eq_interior_of_positive theta profile profilePositive,
    linearResponse_eq_interior_of_positive theta (profile + perturbation) perturbedPositive]
  exact interiorLinearResponse_add_sub theta profile perturbation

def interiorResponseRegion {groupSize : Nat} (theta : Fin groupSize → ℝ) :
    Set (FixedGroupProfile groupSize) :=
  {profile | ∀ agent, 0 < linearFixedGroupResponse theta profile agent}

theorem isOpen_interiorResponseRegion {groupSize : Nat}
    (theta : Fin groupSize → ℝ) : IsOpen (interiorResponseRegion theta) := by
  rw [show interiorResponseRegion theta =
      ⋂ agent, {profile | 0 < linearFixedGroupResponse theta profile agent} by
    ext profile
    simp [interiorResponseRegion]]
  apply isOpen_iInter_of_finite
  intro agent
  exact isOpen_lt continuous_const
    ((continuous_apply agent).comp (linearFixedGroupResponse_continuous theta))

theorem interiorResponseRegion_mem_nhds {groupSize : Nat}
    (theta : Fin groupSize → ℝ) (profile : FixedGroupProfile groupSize)
    (positive : ∀ agent, 0 < linearFixedGroupResponse theta profile agent) :
    interiorResponseRegion theta ∈ nhds profile := by
  exact (isOpen_interiorResponseRegion theta).mem_nhds positive

theorem linearResponse_eq_affine_on_interiorRegion {groupSize : Nat}
    (theta : Fin groupSize → ℝ) :
    Set.EqOn (linearFixedGroupResponse theta) (interiorLinearResponse theta)
      (interiorResponseRegion theta) := by
  intro profile profileInterior
  exact linearResponse_eq_interior_of_positive theta profile profileInterior

theorem homogeneousLinearResponse_unstable (theta : ℝ) (groupSize : Nat)
    (groupSizePositive : 0 < groupSize)
    (beyondBoundary : 1 < (1 - theta) * (groupSize - 1 : Nat)) :
    IsLinearlyUnstable (linearResponseJacobian (fun _ : Fin groupSize => theta)) := by
  let vector : Fin groupSize → ℝ := fun _ => 1
  let eigenvalue : ℝ := -(1 - theta) * (groupSize - 1 : Nat)
  refine ⟨vector, eigenvalue, ?_, ?_, ?_⟩
  · intro vectorZero
    have agent : Fin groupSize := ⟨0, groupSizePositive⟩
    have := congrFun vectorZero agent
    simp [vector] at this
  · exact homogeneousJacobian_mulVec_one theta groupSize
  · have productNonnegative : 0 ≤ (1 - theta) * (groupSize - 1 : Nat) := by
      exact le_trans zero_le_one (le_of_lt beyondBoundary)
    rw [show eigenvalue = -((1 - theta) * (groupSize - 1 : Nat)) by
      dsimp [eigenvalue]; ring, abs_neg, abs_of_nonneg productNonnegative]
    exact beyondBoundary

end AgenticAxtell.Baseline
