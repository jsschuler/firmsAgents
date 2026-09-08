// Lean compiler output
// Module: AgenticAxtell.Baseline.NonlinearFixedGroup
// Imports: public import Init public import AgenticAxtell.Baseline.NonlinearBestResponse public import Gametheory.Brouwer_product public import Mathlib.Analysis.Convex.StdSimplex public import AgenticAxtell.Baseline.FixedGroup
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
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__0___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__1(lean_object*, lean_object*);
lean_object* l_List_finRange(lean_object*);
lean_object* lp_mathlib_Multiset_filter___redArg(lean_object*, lean_object*);
lean_object* lp_mathlib_Finset_sum___at___00BoundingSieve_multSum_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__0(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3;
x_3 = lean_nat_dec_eq(x_2, x_1);
if (x_3 == 0)
{
uint8_t x_4;
x_4 = 1;
return x_4;
}
else
{
uint8_t x_5;
x_5 = 0;
return x_5;
}
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__0___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4;
x_3 = lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__0(x_1, x_2);
lean_dec(x_2);
lean_dec(x_1);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__1(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3;
x_3 = lean_apply_1(x_1, x_2);
return x_3;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8;
x_4 = lean_alloc_closure((void*)(lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__0___boxed), 2, 1);
lean_closure_set(x_4, 0, x_3);
x_5 = lean_alloc_closure((void*)(lp_AgenticAxtell_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___lam__1), 2, 1);
lean_closure_set(x_5, 0, x_2);
x_6 = l_List_finRange(x_1);
x_7 = lp_mathlib_Multiset_filter___redArg(x_4, x_6);
x_8 = lp_mathlib_Finset_sum___at___00BoundingSieve_multSum_spec__0___redArg(x_7, x_5);
return x_8;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearBestResponse(uint8_t builtin);
lean_object* initialize_Gametheory_Gametheory_Brouwer__product(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib_Analysis_Convex_StdSimplex(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_FixedGroup(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearFixedGroup(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearBestResponse(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_Gametheory_Gametheory_Brouwer__product(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib_Analysis_Convex_StdSimplex(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_FixedGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
