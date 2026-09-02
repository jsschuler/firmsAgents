// Lean compiler output
// Module: AgenticAxtell.Baseline.LinearBestResponse
// Imports: Init AgenticAxtell.Baseline.FixedGroup Mathlib.Analysis.MeanInequalities
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
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_interactionCount___boxed(lean_object*);
extern lean_object* l___private_Mathlib_Data_Real_Basic_0__Real_zero;
lean_object* l_AgenticAxtell_Baseline_fixedGroupOtherEffort(lean_object*, lean_object*, lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_3258_(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearBestResponseCandidate(lean_object*, lean_object*);
lean_object* l_Nat_cast___at_Real_instNatCast___spec__2(lean_object*);
extern lean_object* l___private_Mathlib_Data_Real_Basic_0__Real_one;
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_interactionCount(lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearFixedGroupResponse(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(lean_object*, lean_object*);
lean_object* lean_nat_sub(lean_object*, lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearBestResponseCandidate(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; 
lean_inc(x_1);
x_3 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_1);
x_4 = l___private_Mathlib_Data_Real_Basic_0__Real_one;
x_5 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_4, x_3);
x_6 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_5, x_2);
x_7 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_6);
x_8 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_1, x_7);
x_9 = l___private_Mathlib_Data_Real_Basic_0__Real_zero;
x_10 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_3258_(x_9, x_8);
return x_10;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearFixedGroupResponse(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; lean_object* x_6; lean_object* x_7; 
lean_inc(x_4);
x_5 = lean_apply_1(x_2, x_4);
x_6 = l_AgenticAxtell_Baseline_fixedGroupOtherEffort(x_1, x_3, x_4);
lean_dec(x_4);
x_7 = l_AgenticAxtell_Baseline_linearBestResponseCandidate(x_5, x_6);
return x_7;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_interactionCount(lean_object* x_1) {
_start:
{
lean_object* x_2; lean_object* x_3; lean_object* x_4; 
x_2 = lean_unsigned_to_nat(1u);
x_3 = lean_nat_sub(x_1, x_2);
x_4 = l_Nat_cast___at_Real_instNatCast___spec__2(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_interactionCount___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_AgenticAxtell_Baseline_interactionCount(x_1);
lean_dec(x_1);
return x_2;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_FixedGroup(uint8_t builtin, lean_object*);
lean_object* initialize_Mathlib_Analysis_MeanInequalities(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_Baseline_LinearBestResponse(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_FixedGroup(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Mathlib_Analysis_MeanInequalities(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
