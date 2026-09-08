// Lean compiler output
// Module: AgenticAxtell.Baseline.LinearBestResponse
// Imports: public import Init public import AgenticAxtell.Baseline.FixedGroup public import Mathlib.Analysis.MeanInequalities
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
extern lean_object* lp_mathlib_Real_definition_00___x40_Mathlib_Data_Real_Basic_1850581184____hygCtx___hyg_8_;
extern lean_object* lp_mathlib_Real_definition_00___x40_Mathlib_Data_Real_Basic_1279875089____hygCtx___hyg_8_;
lean_object* lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_2451848184____hygCtx___hyg_8_(lean_object*, lean_object*);
lean_object* lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_3793047190____hygCtx___hyg_8_(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_linearBestResponseCandidate(lean_object*, lean_object*);
lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_fixedGroupOtherEffort(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_linearFixedGroupResponse(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_nat_sub(lean_object*, lean_object*);
lean_object* lp_mathlib_Nat_cast___at___00Nat_cast___at___00Nat_cast___at___00Nat_cast___at___00__private_Mathlib_NumberTheory_ModularForms_EisensteinSeries_E2_Transform_0__EisensteinSeries_00_u03b4_spec__0_spec__0_spec__2_spec__3(lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_interactionCount(lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_interactionCount___boxed(lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_linearBestResponseCandidate(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10;
x_3 = lp_mathlib_Real_definition_00___x40_Mathlib_Data_Real_Basic_1850581184____hygCtx___hyg_8_;
x_4 = lp_mathlib_Real_definition_00___x40_Mathlib_Data_Real_Basic_1279875089____hygCtx___hyg_8_;
lean_inc(x_1);
x_5 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_2451848184____hygCtx___hyg_8_), 2, 1);
lean_closure_set(x_5, 0, x_1);
x_6 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_6, 0, x_4);
lean_closure_set(x_6, 1, x_5);
x_7 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_7, 0, x_6);
lean_closure_set(x_7, 1, x_2);
x_8 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_2451848184____hygCtx___hyg_8_), 2, 1);
lean_closure_set(x_8, 0, x_7);
x_9 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_9, 0, x_1);
lean_closure_set(x_9, 1, x_8);
x_10 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_3793047190____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_10, 0, x_3);
lean_closure_set(x_10, 1, x_9);
return x_10;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_linearFixedGroupResponse(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; lean_object* x_6; lean_object* x_7;
lean_inc(x_4);
x_5 = lean_apply_1(x_2, x_4);
x_6 = lp_AgenticAxtell_AgenticAxtell_Baseline_fixedGroupOtherEffort(x_1, x_3, x_4);
x_7 = lp_AgenticAxtell_AgenticAxtell_Baseline_linearBestResponseCandidate(x_5, x_6);
return x_7;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_interactionCount(lean_object* x_1) {
_start:
{
lean_object* x_2; lean_object* x_3; lean_object* x_4;
x_2 = lean_unsigned_to_nat(1u);
x_3 = lean_nat_sub(x_1, x_2);
x_4 = lp_mathlib_Nat_cast___at___00Nat_cast___at___00Nat_cast___at___00Nat_cast___at___00__private_Mathlib_NumberTheory_ModularForms_EisensteinSeries_E2_Transform_0__EisensteinSeries_00_u03b4_spec__0_spec__0_spec__2_spec__3(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_interactionCount___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2;
x_2 = lp_AgenticAxtell_AgenticAxtell_Baseline_interactionCount(x_1);
lean_dec(x_1);
return x_2;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_FixedGroup(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Analysis_MeanInequalities(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_LinearBestResponse(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_FixedGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Analysis_MeanInequalities(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
