// Lean compiler output
// Module: AgenticAxtell.Baseline.Candidates
// Imports: public import Init public import AgenticAxtell.Baseline.BestResponse
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
LEAN_EXPORT uint8_t lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f___lam__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f___lam__0___boxed(lean_object*, lean_object*);
lean_object* l_List_find_x3f___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f(lean_object*, lean_object*);
uint8_t lean_usize_dec_eq(size_t, size_t);
size_t lean_usize_sub(size_t, size_t);
lean_object* lean_array_uget_borrowed(lean_object*, size_t);
uint8_t l_List_elem___at___00Lean_Meta_Grind_Arith_Cutsat_checkElimEqs_spec__0(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1_spec__2(lean_object*, size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1_spec__2___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
lean_object* lean_array_mk(lean_object*);
lean_object* lean_array_get_size(lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
size_t lean_usize_of_nat(lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1(lean_object*, lean_object*);
lean_object* lean_array_to_list(lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_filterMapTR_go___at___00AgenticAxtell_Baseline_candidateFirms_spec__0(lean_object*, lean_object*, lean_object*);
lean_object* lean_array_push(lean_object*, lean_object*);
lean_object* lean_mk_empty_array_with_capacity(lean_object*);
static lean_once_cell_t lp_AgenticAxtell_AgenticAxtell_Baseline_candidateFirms___closed__0_once = LEAN_ONCE_CELL_INITIALIZER;
static lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_candidateFirms___closed__0;
lean_object* lp_mathlib_List_pwFilter___at___00List_dedup___at___00Multiset_dedup___at___00Multiset_toFinset___at___00List_toFinset___at___00Finset_equivBitIndices_spec__0_spec__0_spec__1_spec__4_spec__5___redArg(lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_candidateFirms(lean_object*, lean_object*);
lean_object* l_List_reverse___redArg(lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_filterTR_loop___at___00AgenticAxtell_Baseline_candidateSize_spec__0(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_filterTR_loop___at___00AgenticAxtell_Baseline_candidateSize_spec__0___boxed(lean_object*, lean_object*, lean_object*);
lean_object* l_List_lengthTR___redArg(lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_candidateSize(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_candidateSize___boxed(lean_object*, lean_object*, lean_object*);
LEAN_EXPORT uint8_t lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f___lam__0(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; uint8_t x_4;
x_3 = lean_ctor_get(x_2, 0);
x_4 = lean_nat_dec_eq(x_3, x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f___lam__0___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4;
x_3 = lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f___lam__0(x_1, x_2);
lean_dec_ref(x_2);
lean_dec(x_1);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5;
x_3 = lean_ctor_get(x_1, 0);
lean_inc(x_3);
lean_dec_ref(x_1);
x_4 = lean_alloc_closure((void*)(lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f___lam__0___boxed), 2, 1);
lean_closure_set(x_4, 0, x_2);
x_5 = l_List_find_x3f___redArg(x_4, x_3);
return x_5;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1_spec__2(lean_object* x_1, size_t x_2, size_t x_3, lean_object* x_4) {
_start:
{
uint8_t x_5;
x_5 = lean_usize_dec_eq(x_2, x_3);
if (x_5 == 0)
{
size_t x_6; size_t x_7; lean_object* x_8; uint8_t x_9;
x_6 = 1;
x_7 = lean_usize_sub(x_2, x_6);
x_8 = lean_array_uget_borrowed(x_1, x_7);
x_9 = l_List_elem___at___00Lean_Meta_Grind_Arith_Cutsat_checkElimEqs_spec__0(x_8, x_4);
if (x_9 == 0)
{
lean_object* x_10;
lean_inc(x_8);
x_10 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_10, 0, x_8);
lean_ctor_set(x_10, 1, x_4);
x_2 = x_7;
x_4 = x_10;
goto _start;
}
else
{
x_2 = x_7;
goto _start;
}
}
else
{
return x_4;
}
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1_spec__2___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
size_t x_5; size_t x_6; lean_object* x_7;
x_5 = lean_unbox_usize(x_2);
lean_dec(x_2);
x_6 = lean_unbox_usize(x_3);
lean_dec(x_3);
x_7 = lp_AgenticAxtell___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1_spec__2(x_1, x_5, x_6, x_4);
lean_dec_ref(x_1);
return x_7;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; uint8_t x_6;
x_3 = lean_array_mk(x_2);
x_4 = lean_array_get_size(x_3);
x_5 = lean_unsigned_to_nat(0u);
x_6 = lean_nat_dec_lt(x_5, x_4);
if (x_6 == 0)
{
lean_dec_ref(x_3);
return x_1;
}
else
{
size_t x_7; size_t x_8; lean_object* x_9;
x_7 = lean_usize_of_nat(x_4);
x_8 = 0;
x_9 = lp_AgenticAxtell___private_Init_Data_Array_Basic_0__Array_foldrMUnsafe_fold___at___00List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1_spec__2(x_3, x_7, x_8, x_1);
lean_dec_ref(x_3);
return x_9;
}
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3;
x_3 = lp_AgenticAxtell_List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1(x_2, x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_filterMapTR_go___at___00AgenticAxtell_Baseline_candidateFirms_spec__0(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
if (lean_obj_tag(x_2) == 0)
{
lean_object* x_4;
lean_dec_ref(x_1);
x_4 = lean_array_to_list(x_3);
return x_4;
}
else
{
lean_object* x_5; lean_object* x_6; lean_object* x_7;
x_5 = lean_ctor_get(x_2, 0);
lean_inc(x_5);
x_6 = lean_ctor_get(x_2, 1);
lean_inc(x_6);
lean_dec_ref(x_2);
lean_inc_ref(x_1);
x_7 = lp_AgenticAxtell_AgenticAxtell_Baseline_findAgent_x3f(x_1, x_5);
if (lean_obj_tag(x_7) == 0)
{
x_2 = x_6;
goto _start;
}
else
{
lean_object* x_9; lean_object* x_10; lean_object* x_11;
x_9 = lean_ctor_get(x_7, 0);
lean_inc(x_9);
lean_dec_ref(x_7);
x_10 = lean_ctor_get(x_9, 3);
lean_inc(x_10);
lean_dec(x_9);
x_11 = lean_array_push(x_3, x_10);
x_2 = x_6;
x_3 = x_11;
goto _start;
}
}
}
}
static lean_object* _init_lp_AgenticAxtell_AgenticAxtell_Baseline_candidateFirms___closed__0(void) {
_start:
{
lean_object* x_1; lean_object* x_2;
x_1 = lean_unsigned_to_nat(0u);
x_2 = lean_mk_empty_array_with_capacity(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_candidateFirms(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13;
x_3 = lean_ctor_get(x_2, 3);
lean_inc(x_3);
x_4 = lean_ctor_get(x_2, 4);
lean_inc(x_4);
lean_dec_ref(x_2);
x_5 = lean_ctor_get(x_1, 1);
lean_inc(x_5);
x_6 = lean_obj_once(&lp_AgenticAxtell_AgenticAxtell_Baseline_candidateFirms___closed__0, &lp_AgenticAxtell_AgenticAxtell_Baseline_candidateFirms___closed__0_once, _init_lp_AgenticAxtell_AgenticAxtell_Baseline_candidateFirms___closed__0);
x_7 = lp_AgenticAxtell_List_filterMapTR_go___at___00AgenticAxtell_Baseline_candidateFirms_spec__0(x_1, x_4, x_6);
x_8 = lean_box(0);
x_9 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_9, 0, x_3);
lean_ctor_set(x_9, 1, x_8);
x_10 = lp_mathlib_List_pwFilter___at___00List_dedup___at___00Multiset_dedup___at___00Multiset_toFinset___at___00List_toFinset___at___00Finset_equivBitIndices_spec__0_spec__0_spec__1_spec__4_spec__5___redArg(x_7);
x_11 = lp_AgenticAxtell_List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1(x_10, x_9);
x_12 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_12, 0, x_5);
lean_ctor_set(x_12, 1, x_8);
x_13 = lp_AgenticAxtell_List_foldrTR___at___00Multiset_ndunion___at___00AgenticAxtell_Baseline_candidateFirms_spec__1_spec__1(x_12, x_11);
return x_13;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_filterTR_loop___at___00AgenticAxtell_Baseline_candidateSize_spec__0(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
if (lean_obj_tag(x_2) == 0)
{
lean_object* x_4;
x_4 = l_List_reverse___redArg(x_3);
return x_4;
}
else
{
uint8_t x_5;
x_5 = !lean_is_exclusive(x_2);
if (x_5 == 0)
{
lean_object* x_6; lean_object* x_7; lean_object* x_8; uint8_t x_9;
x_6 = lean_ctor_get(x_2, 0);
x_7 = lean_ctor_get(x_2, 1);
x_8 = lean_ctor_get(x_6, 3);
x_9 = lean_nat_dec_eq(x_8, x_1);
if (x_9 == 0)
{
lean_free_object(x_2);
lean_dec(x_6);
x_2 = x_7;
goto _start;
}
else
{
lean_ctor_set(x_2, 1, x_3);
{
lean_object* _tmp_1 = x_7;
lean_object* _tmp_2 = x_2;
x_2 = _tmp_1;
x_3 = _tmp_2;
}
goto _start;
}
}
else
{
lean_object* x_12; lean_object* x_13; lean_object* x_14; uint8_t x_15;
x_12 = lean_ctor_get(x_2, 0);
x_13 = lean_ctor_get(x_2, 1);
lean_inc(x_13);
lean_inc(x_12);
lean_dec(x_2);
x_14 = lean_ctor_get(x_12, 3);
x_15 = lean_nat_dec_eq(x_14, x_1);
if (x_15 == 0)
{
lean_dec(x_12);
x_2 = x_13;
goto _start;
}
else
{
lean_object* x_17;
x_17 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_17, 0, x_12);
lean_ctor_set(x_17, 1, x_3);
x_2 = x_13;
x_3 = x_17;
goto _start;
}
}
}
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_List_filterTR_loop___at___00AgenticAxtell_Baseline_candidateSize_spec__0___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4;
x_4 = lp_AgenticAxtell_List_filterTR_loop___at___00AgenticAxtell_Baseline_candidateSize_spec__0(x_1, x_2, x_3);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_candidateSize(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; lean_object* x_5; uint8_t x_6;
x_4 = lean_ctor_get(x_1, 0);
lean_inc(x_4);
x_5 = lean_ctor_get(x_1, 1);
lean_inc(x_5);
lean_dec_ref(x_1);
x_6 = lean_nat_dec_eq(x_3, x_5);
lean_dec(x_5);
if (x_6 == 0)
{
lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; uint8_t x_11;
x_7 = lean_ctor_get(x_2, 3);
x_8 = lean_box(0);
x_9 = lp_AgenticAxtell_List_filterTR_loop___at___00AgenticAxtell_Baseline_candidateSize_spec__0(x_3, x_4, x_8);
x_10 = l_List_lengthTR___redArg(x_9);
lean_dec(x_9);
x_11 = lean_nat_dec_eq(x_3, x_7);
if (x_11 == 0)
{
lean_object* x_12; lean_object* x_13;
x_12 = lean_unsigned_to_nat(1u);
x_13 = lean_nat_add(x_10, x_12);
lean_dec(x_10);
return x_13;
}
else
{
return x_10;
}
}
else
{
lean_object* x_14;
lean_dec(x_4);
x_14 = lean_unsigned_to_nat(1u);
return x_14;
}
}
}
LEAN_EXPORT lean_object* lp_AgenticAxtell_AgenticAxtell_Baseline_candidateSize___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4;
x_4 = lp_AgenticAxtell_AgenticAxtell_Baseline_candidateSize(x_1, x_2, x_3);
lean_dec(x_3);
lean_dec_ref(x_2);
return x_4;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_BestResponse(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_Candidates(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_BestResponse(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
