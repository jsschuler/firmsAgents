// Lean compiler output
// Module: AgenticAxtell.Baseline.SemanticChoice
// Imports: public import Init public import AgenticAxtell.Baseline.Transition
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
lean_object* l_List_lengthTR___redArg(lean_object*);
lean_object* lean_uint64_to_nat(uint64_t);
lean_object* lean_nat_mod(lean_object*, lean_object*);
lean_object* l_List_get___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw___redArg(lean_object*, uint64_t);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw___redArg___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw(lean_object*, lean_object*, lean_object*, uint64_t);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw___redArg(lean_object* x_1, uint64_t x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6;
x_3 = l_List_lengthTR___redArg(x_1);
x_4 = lean_uint64_to_nat(x_2);
x_5 = lean_nat_mod(x_4, x_3);
lean_dec(x_3);
lean_dec(x_4);
x_6 = l_List_get___redArg(x_1, x_5);
return x_6;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw___redArg___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint64_t x_3; lean_object* x_4;
x_3 = lean_unbox_uint64(x_2);
lean_dec_ref(x_2);
x_4 = lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw___redArg(x_1, x_3);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw(lean_object* x_1, lean_object* x_2, lean_object* x_3, uint64_t x_4) {
_start:
{
lean_object* x_5;
x_5 = lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw___redArg(x_2, x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
uint64_t x_5; lean_object* x_6;
x_5 = lean_unbox_uint64(x_4);
lean_dec_ref(x_4);
x_6 = lp_AgenticAxtell_AgenticAxtell_Baseline_selectByDraw(x_1, x_2, x_3, x_5);
lean_dec(x_2);
return x_6;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_Transition(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_SemanticChoice(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_Transition(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
