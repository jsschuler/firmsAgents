// Lean compiler output
// Module: AgenticAxtell.Baseline.SemanticChoice
// Imports: Init AgenticAxtell.Baseline.Transition
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
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_selectByDraw(lean_object*);
lean_object* l_List_get___rarg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_selectByDraw___rarg___boxed(lean_object*, lean_object*, lean_object*);
lean_object* lean_uint64_to_nat(uint64_t);
lean_object* l_List_lengthTRAux___rarg(lean_object*, lean_object*);
lean_object* lean_nat_mod(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_selectByDraw___rarg(lean_object*, lean_object*, uint64_t);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_selectByDraw___rarg(lean_object* x_1, lean_object* x_2, uint64_t x_3) {
_start:
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; 
x_4 = lean_unsigned_to_nat(0u);
x_5 = l_List_lengthTRAux___rarg(x_1, x_4);
x_6 = lean_uint64_to_nat(x_3);
x_7 = lean_nat_mod(x_6, x_5);
lean_dec(x_5);
lean_dec(x_6);
x_8 = l_List_get___rarg(x_1, x_7);
return x_8;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_selectByDraw(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = lean_alloc_closure((void*)(l_AgenticAxtell_Baseline_selectByDraw___rarg___boxed), 3, 0);
return x_2;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_selectByDraw___rarg___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
uint64_t x_4; lean_object* x_5; 
x_4 = lean_unbox_uint64(x_3);
lean_dec(x_3);
x_5 = l_AgenticAxtell_Baseline_selectByDraw___rarg(x_1, x_2, x_4);
lean_dec(x_1);
return x_5;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_Transition(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_Baseline_SemanticChoice(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_Transition(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
