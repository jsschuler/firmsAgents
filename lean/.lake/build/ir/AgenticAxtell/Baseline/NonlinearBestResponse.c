// Lean compiler output
// Module: AgenticAxtell.Baseline.NonlinearBestResponse
// Imports: Init AgenticAxtell.Baseline.BestResponse AgenticAxtell.Baseline.NonlinearProduction
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
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound(lean_object*, lean_object*);
lean_object* l_Nat_cast___at_Real_instNatCast___spec__2(lean_object*);
static lean_object* l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__1;
extern lean_object* l___private_Mathlib_Data_Real_Basic_0__Real_one;
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_quadraticOthersSensitivityBound(lean_object*, lean_object*, lean_object*);
lean_object* l_npowRec___at_Real_commRing___spec__2(lean_object*, lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_quadraticOthersSensitivity(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(lean_object*, lean_object*);
static lean_object* _init_l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__1() {
_start:
{
lean_object* x_1; lean_object* x_2;
x_1 = lean_unsigned_to_nat(2u);
x_2 = l_Nat_cast___at_Real_instNatCast___spec__2(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16;
x_3 = lean_ctor_get(x_1, 1);
lean_inc(x_3);
x_4 = lean_ctor_get(x_1, 2);
lean_inc(x_4);
lean_dec(x_1);
x_5 = l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__1;
lean_inc(x_4);
x_6 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_5, x_4);
x_7 = l___private_Mathlib_Data_Real_Basic_0__Real_one;
x_8 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_7, x_2);
lean_inc(x_8);
x_9 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_6, x_8);
lean_inc(x_3);
x_10 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_3, x_9);
lean_inc(x_8);
x_11 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_3, x_8);
x_12 = lean_unsigned_to_nat(2u);
x_13 = l_npowRec___at_Real_commRing___spec__2(x_12, x_8);
x_14 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_4, x_13);
x_15 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_11, x_14);
x_16 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_10, x_15);
return x_16;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_quadraticOthersSensitivity(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4, lean_object* x_5) {
_start:
{
lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16; lean_object* x_17; lean_object* x_18; lean_object* x_19; lean_object* x_20; lean_object* x_21; lean_object* x_22; lean_object* x_23; lean_object* x_24;
lean_inc(x_2);
x_6 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_2);
x_7 = l___private_Mathlib_Data_Real_Basic_0__Real_one;
x_8 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_7, x_6);
x_9 = lean_ctor_get(x_1, 1);
lean_inc(x_9);
x_10 = lean_ctor_get(x_1, 2);
lean_inc(x_10);
lean_dec(x_1);
x_11 = l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__1;
lean_inc(x_10);
x_12 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_11, x_10);
lean_inc(x_3);
lean_inc(x_12);
x_13 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_12, x_3);
x_14 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_9, x_13);
x_15 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_4, x_5);
x_16 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_10, x_15);
x_17 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_14, x_16);
x_18 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_8, x_17);
x_19 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_12, x_2);
x_20 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_3);
x_21 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_7, x_20);
x_22 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_19, x_21);
x_23 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_22);
x_24 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_18, x_23);
return x_24;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_quadraticOthersSensitivityBound(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14;
x_4 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_2);
x_5 = l___private_Mathlib_Data_Real_Basic_0__Real_one;
x_6 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_5, x_4);
x_7 = lean_ctor_get(x_1, 1);
lean_inc(x_7);
x_8 = lean_ctor_get(x_1, 2);
lean_inc(x_8);
lean_dec(x_1);
x_9 = l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__1;
x_10 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_9, x_8);
lean_inc(x_10);
x_11 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_7, x_10);
x_12 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_10, x_3);
x_13 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_11, x_12);
x_14 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_6, x_13);
return x_14;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_BestResponse(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_NonlinearProduction(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_Baseline_NonlinearBestResponse(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_BestResponse(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_NonlinearProduction(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__1 = _init_l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__1();
lean_mark_persistent(l_AgenticAxtell_Baseline_quadraticThetaSensitivityBound___closed__1);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
