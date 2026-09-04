// Lean compiler output
// Module: AgenticAxtell.Baseline.NonlinearFixedGroup
// Imports: Init AgenticAxtell.Baseline.NonlinearBestResponse AgenticAxtell.Baseline.FixedGroup
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
LEAN_EXPORT lean_object* l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___boxed(lean_object*);
LEAN_EXPORT lean_object* l_Multiset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__2___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_filterTR_loop___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__3___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Finset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__1___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4(lean_object*);
static lean_object* l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg___closed__1;
uint8_t l_instDecidableNot___rarg(uint8_t);
LEAN_EXPORT lean_object* l_Finset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__1(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Multiset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__2(lean_object*, lean_object*, lean_object*);
lean_object* l_Multiset_map___rarg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_filterTR_loop___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__3(lean_object*, lean_object*, lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
lean_object* l_List_ofFn___rarg(lean_object*, lean_object*);
lean_object* l_List_reverse___rarg(lean_object*);
lean_object* l_List_foldrTR___rarg(lean_object*, lean_object*, lean_object*);
lean_object* l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_(lean_object*, lean_object*);
lean_object* l_List_finRange___lambda__1___boxed(lean_object*);
LEAN_EXPORT lean_object* l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg(lean_object*, lean_object*);
static lean_object* l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___closed__1;
LEAN_EXPORT lean_object* l_List_filterTR_loop___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__3(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
if (lean_obj_tag(x_3) == 0)
{
lean_object* x_5;
x_5 = l_List_reverse___rarg(x_4);
return x_5;
}
else
{
uint8_t x_6;
x_6 = !lean_is_exclusive(x_3);
if (x_6 == 0)
{
lean_object* x_7; lean_object* x_8; uint8_t x_9; uint8_t x_10;
x_7 = lean_ctor_get(x_3, 0);
x_8 = lean_ctor_get(x_3, 1);
x_9 = lean_nat_dec_eq(x_7, x_2);
x_10 = l_instDecidableNot___rarg(x_9);
if (x_10 == 0)
{
lean_free_object(x_3);
lean_dec(x_7);
x_3 = x_8;
goto _start;
}
else
{
lean_ctor_set(x_3, 1, x_4);
{
lean_object* _tmp_2 = x_8;
lean_object* _tmp_3 = x_3;
x_3 = _tmp_2;
x_4 = _tmp_3;
}
goto _start;
}
}
else
{
lean_object* x_13; lean_object* x_14; uint8_t x_15; uint8_t x_16;
x_13 = lean_ctor_get(x_3, 0);
x_14 = lean_ctor_get(x_3, 1);
lean_inc(x_14);
lean_inc(x_13);
lean_dec(x_3);
x_15 = lean_nat_dec_eq(x_13, x_2);
x_16 = l_instDecidableNot___rarg(x_15);
if (x_16 == 0)
{
lean_dec(x_13);
x_3 = x_14;
goto _start;
}
else
{
lean_object* x_18;
x_18 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_18, 0, x_13);
lean_ctor_set(x_18, 1, x_4);
x_3 = x_14;
x_4 = x_18;
goto _start;
}
}
}
}
}
LEAN_EXPORT lean_object* l_Multiset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__2(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; lean_object* x_5;
x_4 = lean_box(0);
x_5 = l_List_filterTR_loop___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__3(x_1, x_2, x_3, x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l_Finset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__1(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4;
x_4 = l_Multiset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__2(x_1, x_2, x_3);
return x_4;
}
}
static lean_object* _init_l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg___closed__1() {
_start:
{
lean_object* x_1;
x_1 = lean_alloc_closure((void*)(l_Real_definition____x40_Mathlib_Data_Real_Basic___hyg_471_), 2, 0);
return x_1;
}
}
LEAN_EXPORT lean_object* l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6;
x_3 = l_Multiset_map___rarg(x_2, x_1);
x_4 = l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg___closed__1;
x_5 = l___private_Mathlib_Data_Real_Basic_0__Real_zero;
x_6 = l_List_foldrTR___rarg(x_4, x_5, x_3);
return x_6;
}
}
LEAN_EXPORT lean_object* l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4(lean_object* x_1) {
_start:
{
lean_object* x_2;
x_2 = lean_alloc_closure((void*)(l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg), 2, 0);
return x_2;
}
}
static lean_object* _init_l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___closed__1() {
_start:
{
lean_object* x_1;
x_1 = lean_alloc_closure((void*)(l_List_finRange___lambda__1___boxed), 1, 0);
return x_1;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7;
x_4 = l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___closed__1;
lean_inc(x_1);
x_5 = l_List_ofFn___rarg(x_1, x_4);
x_6 = l_Multiset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__2(x_1, x_3, x_5);
lean_dec(x_1);
x_7 = l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg(x_6, x_2);
return x_7;
}
}
LEAN_EXPORT lean_object* l_List_filterTR_loop___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__3___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
lean_object* x_5;
x_5 = l_List_filterTR_loop___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__3(x_1, x_2, x_3, x_4);
lean_dec(x_2);
lean_dec(x_1);
return x_5;
}
}
LEAN_EXPORT lean_object* l_Multiset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__2___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4;
x_4 = l_Multiset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__2(x_1, x_2, x_3);
lean_dec(x_2);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* l_Finset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__1___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4;
x_4 = l_Finset_filter___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__1(x_1, x_2, x_3);
lean_dec(x_2);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___boxed(lean_object* x_1) {
_start:
{
lean_object* x_2;
x_2 = l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4(x_1);
lean_dec(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4;
x_4 = l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort(x_1, x_2, x_3);
lean_dec(x_3);
return x_4;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_NonlinearBestResponse(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_FixedGroup(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_Baseline_NonlinearFixedGroup(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_NonlinearBestResponse(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_FixedGroup(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg___closed__1 = _init_l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg___closed__1();
lean_mark_persistent(l_Finset_sum___at_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___spec__4___rarg___closed__1);
l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___closed__1 = _init_l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___closed__1();
lean_mark_persistent(l_AgenticAxtell_Baseline_feasibleFixedGroupOtherEffort___closed__1);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
