// Lean compiler output
// Module: AgenticAxtell.Baseline.LinearStability
// Imports: Init AgenticAxtell.Baseline.LinearBestResponse
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
extern lean_object* l___private_Mathlib_Data_Real_Basic_0__Real_zero;
lean_object* l_AgenticAxtell_Baseline_fixedGroupOtherEffort(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearResponseJacobian(lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_interiorLinearResponse(lean_object*, lean_object*, lean_object*, lean_object*);
extern lean_object* l___private_Mathlib_Data_Real_Basic_0__Real_one;
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearResponseJacobian___rarg___boxed(lean_object*, lean_object*, lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearResponseJacobian___boxed(lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearResponseJacobian___rarg(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearResponseJacobian___rarg(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
uint8_t x_4; 
x_4 = lean_nat_dec_eq(x_2, x_3);
if (x_4 == 0)
{
lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; 
x_5 = lean_apply_1(x_1, x_2);
x_6 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_5);
x_7 = l___private_Mathlib_Data_Real_Basic_0__Real_one;
x_8 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_7, x_6);
x_9 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_8);
return x_9;
}
else
{
lean_object* x_10; 
lean_dec(x_2);
lean_dec(x_1);
x_10 = l___private_Mathlib_Data_Real_Basic_0__Real_zero;
return x_10;
}
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearResponseJacobian(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_AgenticAxtell_Baseline_linearResponseJacobian___rarg___boxed), 3, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearResponseJacobian___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l_AgenticAxtell_Baseline_linearResponseJacobian___rarg(x_1, x_2, x_3);
lean_dec(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_linearResponseJacobian___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_AgenticAxtell_Baseline_linearResponseJacobian(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_interiorLinearResponse(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; 
lean_inc(x_4);
x_5 = lean_apply_1(x_2, x_4);
lean_inc(x_5);
x_6 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_5);
x_7 = l___private_Mathlib_Data_Real_Basic_0__Real_one;
x_8 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_7, x_6);
x_9 = l_AgenticAxtell_Baseline_fixedGroupOtherEffort(x_1, x_3, x_4);
lean_dec(x_4);
x_10 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_664_(x_8, x_9);
x_11 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_579_(x_10);
x_12 = l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(x_5, x_11);
return x_12;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_LinearBestResponse(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_Baseline_LinearStability(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_LinearBestResponse(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
