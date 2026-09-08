// Lean compiler output
// Module: AgenticAxtell.Baseline.NonlinearBestResponse
// Imports: public import Init public import AgenticAxtell.Baseline.BestResponse public import AgenticAxtell.Baseline.NonlinearProduction
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
lean_object* lp_mathlib_Nat_cast___at___00Nat_cast___at___00Nat_cast___at___00Nat_cast___at___00__private_Mathlib_NumberTheory_ModularForms_EisensteinSeries_E2_Transform_0__EisensteinSeries_00_u03b4_spec__0_spec__0_spec__2_spec__3(lean_object*);
static lean_once_cell_t lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0;
lean_object* lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_(lean_object*, lean_object*, lean_object*);
extern lean_object* lp_mathlib_Real_definition_00___x40_Mathlib_Data_Real_Basic_1279875089____hygCtx___hyg_8_;
lean_object* lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_(lean_object*, lean_object*, lean_object*);
lean_object* lp_mathlib_npowRec___at___00Cardinal_cantorFunctionAux_spec__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound(lean_object*, lean_object*);
lean_object* lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_2451848184____hygCtx___hyg_8_(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticOthersSensitivity(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticOthersSensitivityBound(lean_object*, lean_object*, lean_object*);
static lean_object* _init_lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0(void) {
_start:
{
lean_object* x_1; lean_object* x_2;
x_1 = lean_unsigned_to_nat(2u);
x_2 = lp_mathlib_Nat_cast___at___00Nat_cast___at___00Nat_cast___at___00Nat_cast___at___00__private_Mathlib_NumberTheory_ModularForms_EisensteinSeries_E2_Transform_0__EisensteinSeries_00_u03b4_spec__0_spec__0_spec__2_spec__3(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16;
x_3 = lean_ctor_get(x_1, 1);
lean_inc(x_3);
x_4 = lean_ctor_get(x_1, 2);
lean_inc(x_4);
lean_dec_ref(x_1);
x_5 = lean_unsigned_to_nat(2u);
x_6 = lean_obj_once(&lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0, &lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0_once, _init_lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0);
lean_inc(x_4);
x_7 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_7, 0, x_6);
lean_closure_set(x_7, 1, x_4);
x_8 = lp_mathlib_Real_definition_00___x40_Mathlib_Data_Real_Basic_1279875089____hygCtx___hyg_8_;
x_9 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_9, 0, x_8);
lean_closure_set(x_9, 1, x_2);
lean_inc_ref(x_9);
x_10 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_10, 0, x_7);
lean_closure_set(x_10, 1, x_9);
lean_inc(x_3);
x_11 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_11, 0, x_3);
lean_closure_set(x_11, 1, x_10);
lean_inc_ref(x_9);
x_12 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_12, 0, x_3);
lean_closure_set(x_12, 1, x_9);
x_13 = lp_mathlib_npowRec___at___00Cardinal_cantorFunctionAux_spec__0(x_5, x_9);
x_14 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_14, 0, x_4);
lean_closure_set(x_14, 1, x_13);
x_15 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_15, 0, x_12);
lean_closure_set(x_15, 1, x_14);
x_16 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_16, 0, x_11);
lean_closure_set(x_16, 1, x_15);
return x_16;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticOthersSensitivity(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5) {
_start:
{
lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16; lean_object* x_17; lean_object* x_18; lean_object* x_19; lean_object* x_20; lean_object* x_21; lean_object* x_22; lean_object* x_23; lean_object* x_24;
x_6 = lean_ctor_get(x_1, 1);
lean_inc(x_6);
x_7 = lean_ctor_get(x_1, 2);
lean_inc(x_7);
lean_dec_ref(x_1);
x_8 = lp_mathlib_Real_definition_00___x40_Mathlib_Data_Real_Basic_1279875089____hygCtx___hyg_8_;
lean_inc(x_2);
x_9 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_2451848184____hygCtx___hyg_8_), 2, 1);
lean_closure_set(x_9, 0, x_2);
x_10 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_10, 0, x_8);
lean_closure_set(x_10, 1, x_9);
x_11 = lean_obj_once(&lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0, &lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0_once, _init_lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0);
lean_inc(x_7);
x_12 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_12, 0, x_11);
lean_closure_set(x_12, 1, x_7);
lean_inc(x_3);
lean_inc_ref(x_12);
x_13 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_13, 0, x_12);
lean_closure_set(x_13, 1, x_3);
x_14 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_14, 0, x_6);
lean_closure_set(x_14, 1, x_13);
x_15 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_15, 0, x_4);
lean_closure_set(x_15, 1, x_5);
x_16 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_16, 0, x_7);
lean_closure_set(x_16, 1, x_15);
x_17 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_17, 0, x_14);
lean_closure_set(x_17, 1, x_16);
x_18 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_18, 0, x_10);
lean_closure_set(x_18, 1, x_17);
x_19 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_19, 0, x_12);
lean_closure_set(x_19, 1, x_2);
x_20 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_2451848184____hygCtx___hyg_8_), 2, 1);
lean_closure_set(x_20, 0, x_3);
x_21 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_21, 0, x_8);
lean_closure_set(x_21, 1, x_20);
x_22 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_22, 0, x_19);
lean_closure_set(x_22, 1, x_21);
x_23 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_2451848184____hygCtx___hyg_8_), 2, 1);
lean_closure_set(x_23, 0, x_22);
x_24 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_24, 0, x_18);
lean_closure_set(x_24, 1, x_23);
return x_24;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticOthersSensitivityBound(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14;
x_4 = lean_ctor_get(x_1, 1);
lean_inc(x_4);
x_5 = lean_ctor_get(x_1, 2);
lean_inc(x_5);
lean_dec_ref(x_1);
x_6 = lp_mathlib_Real_definition_00___x40_Mathlib_Data_Real_Basic_1279875089____hygCtx___hyg_8_;
x_7 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_2451848184____hygCtx___hyg_8_), 2, 1);
lean_closure_set(x_7, 0, x_2);
x_8 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_8, 0, x_6);
lean_closure_set(x_8, 1, x_7);
x_9 = lean_obj_once(&lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0, &lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0_once, _init_lp_AgenticAxtell_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__0);
x_10 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_10, 0, x_9);
lean_closure_set(x_10, 1, x_5);
lean_inc_ref(x_10);
x_11 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_11, 0, x_4);
lean_closure_set(x_11, 1, x_10);
x_12 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_12, 0, x_10);
lean_closure_set(x_12, 1, x_3);
x_13 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_1138242547____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_13, 0, x_11);
lean_closure_set(x_13, 1, x_12);
x_14 = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(x_14, 0, x_8);
lean_closure_set(x_14, 1, x_13);
return x_14;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_BestResponse(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearProduction(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearBestResponse(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_BestResponse(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearProduction(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
