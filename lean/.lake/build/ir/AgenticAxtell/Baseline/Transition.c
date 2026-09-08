// Lean compiler output
// Module: AgenticAxtell.Baseline.Transition
// Imports: public import Init public import AgenticAxtell.Baseline.Candidates
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
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_updateAgent(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_updateAgent___boxed(lean_object*, lean_object*, lean_object*);
lean_object* l_List_reverse___redArg(lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_mapTR_loop___at___00AgenticAxtell_Baseline_updateSelected_spec__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_mapTR_loop___at___00AgenticAxtell_Baseline_updateSelected_spec__0___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_updateSelected(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_updateSelected___boxed(lean_object*, lean_object*, lean_object*);
lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_transition(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_updateAgent(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; uint8_t x_7;
x_4 = lean_ctor_get(x_3, 0);
x_5 = lean_ctor_get(x_3, 1);
x_6 = lean_ctor_get(x_3, 4);
x_7 = lean_nat_dec_eq(x_4, x_1);
if (x_7 == 0)
{
return x_3;
}
else
{
uint8_t x_8;
lean_inc(x_6);
lean_inc(x_5);
lean_inc(x_4);
x_8 = !lean_is_exclusive(x_3);
if (x_8 == 0)
{
lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14; lean_object* x_15;
x_9 = lean_ctor_get(x_3, 4);
lean_dec(x_9);
x_10 = lean_ctor_get(x_3, 3);
lean_dec(x_10);
x_11 = lean_ctor_get(x_3, 2);
lean_dec(x_11);
x_12 = lean_ctor_get(x_3, 1);
lean_dec(x_12);
x_13 = lean_ctor_get(x_3, 0);
lean_dec(x_13);
x_14 = lean_ctor_get(x_2, 0);
x_15 = lean_ctor_get(x_2, 1);
lean_inc(x_14);
lean_inc(x_15);
lean_ctor_set(x_3, 3, x_14);
lean_ctor_set(x_3, 2, x_15);
return x_3;
}
else
{
lean_object* x_16; lean_object* x_17; lean_object* x_18;
lean_dec(x_3);
x_16 = lean_ctor_get(x_2, 0);
x_17 = lean_ctor_get(x_2, 1);
lean_inc(x_16);
lean_inc(x_17);
x_18 = lean_alloc_ctor(0, 5, 0);
lean_ctor_set(x_18, 0, x_4);
lean_ctor_set(x_18, 1, x_5);
lean_ctor_set(x_18, 2, x_17);
lean_ctor_set(x_18, 3, x_16);
lean_ctor_set(x_18, 4, x_6);
return x_18;
}
}
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_updateAgent___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4;
x_4 = lp_AgenticAxtell_AgenticAxtell_Baseline_updateAgent(x_1, x_2, x_3);
lean_dec_ref(x_2);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_mapTR_loop___at___00AgenticAxtell_Baseline_updateSelected_spec__0(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
if (lean_obj_tag(x_3) == 0)
{
lean_object* x_5;
x_5 = l_List_reverse___redArg(x_4);
return x_5;
}
else
{
uint8_t x_6;
x_6 = !lean_is_exclusive(x_3);
if (x_6 == 0)
{
lean_object* x_7; lean_object* x_8; lean_object* x_9;
x_7 = lean_ctor_get(x_3, 0);
x_8 = lean_ctor_get(x_3, 1);
x_9 = lp_AgenticAxtell_AgenticAxtell_Baseline_updateAgent(x_1, x_2, x_7);
lean_ctor_set(x_3, 1, x_4);
lean_ctor_set(x_3, 0, x_9);
{
lean_object* _tmp_2 = x_8;
lean_object* _tmp_3 = x_3;
x_3 = _tmp_2;
x_4 = _tmp_3;
}
goto _start;
}
else
{
lean_object* x_11; lean_object* x_12; lean_object* x_13; lean_object* x_14;
x_11 = lean_ctor_get(x_3, 0);
x_12 = lean_ctor_get(x_3, 1);
lean_inc(x_12);
lean_inc(x_11);
lean_dec(x_3);
x_13 = lp_AgenticAxtell_AgenticAxtell_Baseline_updateAgent(x_1, x_2, x_11);
x_14 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_14, 0, x_13);
lean_ctor_set(x_14, 1, x_4);
x_3 = x_12;
x_4 = x_14;
goto _start;
}
}
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_mapTR_loop___at___00AgenticAxtell_Baseline_updateSelected_spec__0___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5;
x_5 = lp_AgenticAxtell_List_mapTR_loop___at___00AgenticAxtell_Baseline_updateSelected_spec__0(x_1, x_2, x_3, x_4);
lean_dec_ref(x_2);
lean_dec(x_1);
return x_5;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_updateSelected(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
uint8_t x_4;
x_4 = !lean_is_exclusive(x_1);
if (x_4 == 0)
{
lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; uint8_t x_10;
x_5 = lean_ctor_get(x_1, 0);
x_6 = lean_ctor_get(x_1, 1);
x_7 = lean_ctor_get(x_3, 0);
x_8 = lean_box(0);
x_9 = lp_AgenticAxtell_List_mapTR_loop___at___00AgenticAxtell_Baseline_updateSelected_spec__0(x_2, x_3, x_5, x_8);
x_10 = lean_nat_dec_eq(x_7, x_6);
if (x_10 == 0)
{
lean_ctor_set(x_1, 0, x_9);
return x_1;
}
else
{
lean_object* x_11; lean_object* x_12;
x_11 = lean_unsigned_to_nat(1u);
x_12 = lean_nat_add(x_6, x_11);
lean_dec(x_6);
lean_ctor_set(x_1, 1, x_12);
lean_ctor_set(x_1, 0, x_9);
return x_1;
}
}
else
{
lean_object* x_13; lean_object* x_14; lean_object* x_15; lean_object* x_16; lean_object* x_17; uint8_t x_18;
x_13 = lean_ctor_get(x_1, 0);
x_14 = lean_ctor_get(x_1, 1);
lean_inc(x_14);
lean_inc(x_13);
lean_dec(x_1);
x_15 = lean_ctor_get(x_3, 0);
x_16 = lean_box(0);
x_17 = lp_AgenticAxtell_List_mapTR_loop___at___00AgenticAxtell_Baseline_updateSelected_spec__0(x_2, x_3, x_13, x_16);
x_18 = lean_nat_dec_eq(x_15, x_14);
if (x_18 == 0)
{
lean_object* x_19;
x_19 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_19, 0, x_17);
lean_ctor_set(x_19, 1, x_14);
return x_19;
}
else
{
lean_object* x_20; lean_object* x_21; lean_object* x_22;
x_20 = lean_unsigned_to_nat(1u);
x_21 = lean_nat_add(x_14, x_20);
lean_dec(x_14);
x_22 = lean_alloc_ctor(0, 2, 0);
lean_ctor_set(x_22, 0, x_17);
lean_ctor_set(x_22, 1, x_21);
return x_22;
}
}
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_updateSelected___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4;
x_4 = lp_AgenticAxtell_AgenticAxtell_Baseline_updateSelected(x_1, x_2, x_3);
lean_dec_ref(x_3);
lean_dec(x_2);
return x_4;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_transition(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5; lean_object* x_6;
x_5 = lean_ctor_get(x_4, 0);
lean_inc(x_5);
lean_inc_ref(x_3);
x_6 = lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f(x_3, x_5);
if (lean_obj_tag(x_6) == 0)
{
lean_dec_ref(x_4);
lean_dec_ref(x_2);
lean_dec_ref(x_1);
return x_3;
}
else
{
lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10;
x_7 = lean_ctor_get(x_6, 0);
lean_inc(x_7);
lean_dec_ref(x_6);
x_8 = lean_ctor_get(x_7, 0);
lean_inc(x_8);
lean_inc_ref(x_3);
x_9 = lean_apply_4(x_1, x_2, x_3, x_7, x_4);
x_10 = lp_AgenticAxtell_AgenticAxtell_Baseline_updateSelected(x_3, x_8, x_9);
lean_dec_ref(x_9);
lean_dec(x_8);
return x_10;
}
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_Candidates(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_Transition(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_Candidates(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
