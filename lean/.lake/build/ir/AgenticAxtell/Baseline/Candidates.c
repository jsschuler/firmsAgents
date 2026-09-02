// Lean compiler output
// Module: AgenticAxtell.Baseline.Candidates
// Imports: Init AgenticAxtell.Baseline.BestResponse
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
static lean_object* l_AgenticAxtell_Baseline_candidateFirms___closed__1;
LEAN_EXPORT uint8_t l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8___lambda__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_filterTR_loop___at_AgenticAxtell_Baseline_candidateSize___spec__1(lean_object*, lean_object*, lean_object*);
lean_object* lean_array_push(lean_object*, lean_object*);
uint8_t lean_usize_dec_eq(size_t, size_t);
LEAN_EXPORT lean_object* l_List_pwFilter___at_AgenticAxtell_Baseline_candidateFirms___spec__6(lean_object*);
lean_object* l_List_find_x3f___rarg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_candidateSize___boxed(lean_object*, lean_object*, lean_object*);
uint8_t l_List_elem___at_AgenticAxtell_Baseline_activeFirms___spec__4(lean_object*, lean_object*);
size_t lean_usize_of_nat(lean_object*);
uint8_t l_instDecidableNot___rarg(uint8_t);
LEAN_EXPORT lean_object* l_Multiset_ndunion___at_AgenticAxtell_Baseline_candidateFirms___spec__9(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_toFinset___at_AgenticAxtell_Baseline_candidateFirms___spec__2(lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_candidateSize(lean_object*, lean_object*, lean_object*);
lean_object* lean_array_to_list(lean_object*);
LEAN_EXPORT lean_object* l_List_filterTR_loop___at_AgenticAxtell_Baseline_candidateSize___spec__1___boxed(lean_object*, lean_object*, lean_object*);
lean_object* l_List_lengthTRAux___rarg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__12(lean_object*, size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* l_List_dedup___at_AgenticAxtell_Baseline_candidateFirms___spec__5(lean_object*);
LEAN_EXPORT lean_object* l_Multiset_toFinset___at_AgenticAxtell_Baseline_candidateFirms___spec__3(lean_object*);
LEAN_EXPORT lean_object* l_List_filterMapTR_go___at_AgenticAxtell_Baseline_candidateFirms___spec__1(lean_object*, lean_object*, lean_object*);
uint8_t l_List_decidableBAll___rarg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8___lambda__1___boxed(lean_object*, lean_object*);
LEAN_EXPORT uint8_t l_AgenticAxtell_Baseline_findAgent_x3f___lambda__1(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_candidateFirms(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__12___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_findAgent_x3f___lambda__1___boxed(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_foldrTR___at_AgenticAxtell_Baseline_candidateFirms___spec__7(lean_object*, lean_object*);
uint8_t lean_nat_dec_eq(lean_object*, lean_object*);
uint8_t lean_nat_dec_lt(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8___boxed(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_List_insert___at_AgenticAxtell_Baseline_candidateFirms___spec__10(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_findAgent_x3f(lean_object*, lean_object*);
lean_object* l_List_reverse___rarg(lean_object*);
size_t lean_usize_sub(size_t, size_t);
lean_object* lean_array_mk(lean_object*);
lean_object* lean_array_uget(lean_object*, size_t);
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8(lean_object*, size_t, size_t, lean_object*);
LEAN_EXPORT lean_object* l_List_foldrTR___at_AgenticAxtell_Baseline_candidateFirms___spec__11(lean_object*, lean_object*);
lean_object* lean_array_get_size(lean_object*);
lean_object* lean_nat_add(lean_object*, lean_object*);
LEAN_EXPORT lean_object* l_Multiset_dedup___at_AgenticAxtell_Baseline_candidateFirms___spec__4(lean_object*);
LEAN_EXPORT uint8_t l_AgenticAxtell_Baseline_findAgent_x3f___lambda__1(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; uint8_t x_4; 
x_3 = lean_ctor_get(x_2, 0);
x_4 = lean_nat_dec_eq(x_3, x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_findAgent_x3f(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; 
x_3 = lean_alloc_closure((void*)(l_AgenticAxtell_Baseline_findAgent_x3f___lambda__1___boxed), 2, 1);
lean_closure_set(x_3, 0, x_2);
x_4 = lean_ctor_get(x_1, 0);
lean_inc(x_4);
lean_dec(x_1);
x_5 = l_List_find_x3f___rarg(x_3, x_4);
return x_5;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_findAgent_x3f___lambda__1___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4; 
x_3 = l_AgenticAxtell_Baseline_findAgent_x3f___lambda__1(x_1, x_2);
lean_dec(x_2);
lean_dec(x_1);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_List_filterMapTR_go___at_AgenticAxtell_Baseline_candidateFirms___spec__1(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
if (lean_obj_tag(x_2) == 0)
{
lean_object* x_4; 
lean_dec(x_1);
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
lean_dec(x_2);
lean_inc(x_1);
x_7 = l_AgenticAxtell_Baseline_findAgent_x3f(x_1, x_5);
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
lean_dec(x_7);
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
LEAN_EXPORT uint8_t l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8___lambda__1(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; uint8_t x_4; 
x_3 = lean_nat_dec_eq(x_1, x_2);
x_4 = l_instDecidableNot___rarg(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8(lean_object* x_1, size_t x_2, size_t x_3, lean_object* x_4) {
_start:
{
uint8_t x_5; 
x_5 = lean_usize_dec_eq(x_2, x_3);
if (x_5 == 0)
{
size_t x_6; size_t x_7; lean_object* x_8; lean_object* x_9; uint8_t x_10; 
x_6 = 1;
x_7 = lean_usize_sub(x_2, x_6);
x_8 = lean_array_uget(x_1, x_7);
lean_inc(x_8);
x_9 = lean_alloc_closure((void*)(l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8___lambda__1___boxed), 2, 1);
lean_closure_set(x_9, 0, x_8);
lean_inc(x_4);
x_10 = l_List_decidableBAll___rarg(x_9, x_4);
if (x_10 == 0)
{
lean_dec(x_8);
x_2 = x_7;
goto _start;
}
else
{
lean_object* x_12; 
x_12 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_12, 0, x_8);
lean_ctor_set(x_12, 1, x_4);
x_2 = x_7;
x_4 = x_12;
goto _start;
}
}
else
{
return x_4;
}
}
}
LEAN_EXPORT lean_object* l_List_foldrTR___at_AgenticAxtell_Baseline_candidateFirms___spec__7(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; uint8_t x_6; 
x_3 = lean_array_mk(x_2);
x_4 = lean_array_get_size(x_3);
x_5 = lean_unsigned_to_nat(0u);
x_6 = lean_nat_dec_lt(x_5, x_4);
if (x_6 == 0)
{
lean_dec(x_4);
lean_dec(x_3);
return x_1;
}
else
{
size_t x_7; size_t x_8; lean_object* x_9; 
x_7 = lean_usize_of_nat(x_4);
lean_dec(x_4);
x_8 = 0;
x_9 = l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8(x_3, x_7, x_8, x_1);
lean_dec(x_3);
return x_9;
}
}
}
LEAN_EXPORT lean_object* l_List_pwFilter___at_AgenticAxtell_Baseline_candidateFirms___spec__6(lean_object* x_1) {
_start:
{
lean_object* x_2; lean_object* x_3; 
x_2 = lean_box(0);
x_3 = l_List_foldrTR___at_AgenticAxtell_Baseline_candidateFirms___spec__7(x_2, x_1);
return x_3;
}
}
LEAN_EXPORT lean_object* l_List_dedup___at_AgenticAxtell_Baseline_candidateFirms___spec__5(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_List_pwFilter___at_AgenticAxtell_Baseline_candidateFirms___spec__6(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_Multiset_dedup___at_AgenticAxtell_Baseline_candidateFirms___spec__4(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_List_pwFilter___at_AgenticAxtell_Baseline_candidateFirms___spec__6(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_Multiset_toFinset___at_AgenticAxtell_Baseline_candidateFirms___spec__3(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_List_pwFilter___at_AgenticAxtell_Baseline_candidateFirms___spec__6(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_List_toFinset___at_AgenticAxtell_Baseline_candidateFirms___spec__2(lean_object* x_1) {
_start:
{
lean_object* x_2; 
x_2 = l_List_pwFilter___at_AgenticAxtell_Baseline_candidateFirms___spec__6(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_List_insert___at_AgenticAxtell_Baseline_candidateFirms___spec__10(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; 
x_3 = l_List_elem___at_AgenticAxtell_Baseline_activeFirms___spec__4(x_1, x_2);
if (x_3 == 0)
{
lean_object* x_4; 
x_4 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_4, 0, x_1);
lean_ctor_set(x_4, 1, x_2);
return x_4;
}
else
{
lean_dec(x_1);
return x_2;
}
}
}
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__12(lean_object* x_1, size_t x_2, size_t x_3, lean_object* x_4) {
_start:
{
uint8_t x_5; 
x_5 = lean_usize_dec_eq(x_2, x_3);
if (x_5 == 0)
{
size_t x_6; size_t x_7; lean_object* x_8; lean_object* x_9; 
x_6 = 1;
x_7 = lean_usize_sub(x_2, x_6);
x_8 = lean_array_uget(x_1, x_7);
x_9 = l_List_insert___at_AgenticAxtell_Baseline_candidateFirms___spec__10(x_8, x_4);
x_2 = x_7;
x_4 = x_9;
goto _start;
}
else
{
return x_4;
}
}
}
LEAN_EXPORT lean_object* l_List_foldrTR___at_AgenticAxtell_Baseline_candidateFirms___spec__11(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; uint8_t x_6; 
x_3 = lean_array_mk(x_2);
x_4 = lean_array_get_size(x_3);
x_5 = lean_unsigned_to_nat(0u);
x_6 = lean_nat_dec_lt(x_5, x_4);
if (x_6 == 0)
{
lean_dec(x_4);
lean_dec(x_3);
return x_1;
}
else
{
size_t x_7; size_t x_8; lean_object* x_9; 
x_7 = lean_usize_of_nat(x_4);
lean_dec(x_4);
x_8 = 0;
x_9 = l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__12(x_3, x_7, x_8, x_1);
lean_dec(x_3);
return x_9;
}
}
}
LEAN_EXPORT lean_object* l_Multiset_ndunion___at_AgenticAxtell_Baseline_candidateFirms___spec__9(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; 
x_3 = l_List_foldrTR___at_AgenticAxtell_Baseline_candidateFirms___spec__11(x_2, x_1);
return x_3;
}
}
static lean_object* _init_l_AgenticAxtell_Baseline_candidateFirms___closed__1() {
_start:
{
lean_object* x_1; lean_object* x_2; 
x_1 = lean_box(0);
x_2 = lean_array_mk(x_1);
return x_2;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_candidateFirms(lean_object* x_1, lean_object* x_2) {
_start:
{
lean_object* x_3; lean_object* x_4; lean_object* x_5; lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; lean_object* x_12; lean_object* x_13; 
x_3 = lean_ctor_get(x_2, 4);
lean_inc(x_3);
x_4 = lean_box(0);
x_5 = l_AgenticAxtell_Baseline_candidateFirms___closed__1;
lean_inc(x_1);
x_6 = l_List_filterMapTR_go___at_AgenticAxtell_Baseline_candidateFirms___spec__1(x_1, x_3, x_5);
x_7 = lean_ctor_get(x_2, 3);
lean_inc(x_7);
lean_dec(x_2);
x_8 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_8, 0, x_7);
lean_ctor_set(x_8, 1, x_4);
x_9 = l_List_pwFilter___at_AgenticAxtell_Baseline_candidateFirms___spec__6(x_6);
x_10 = l_List_foldrTR___at_AgenticAxtell_Baseline_candidateFirms___spec__11(x_9, x_8);
x_11 = lean_ctor_get(x_1, 1);
lean_inc(x_11);
lean_dec(x_1);
x_12 = lean_alloc_ctor(1, 2, 0);
lean_ctor_set(x_12, 0, x_11);
lean_ctor_set(x_12, 1, x_4);
x_13 = l_List_foldrTR___at_AgenticAxtell_Baseline_candidateFirms___spec__11(x_12, x_10);
return x_13;
}
}
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8___lambda__1___boxed(lean_object* x_1, lean_object* x_2) {
_start:
{
uint8_t x_3; lean_object* x_4; 
x_3 = l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8___lambda__1(x_1, x_2);
lean_dec(x_2);
lean_dec(x_1);
x_4 = lean_box(x_3);
return x_4;
}
}
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
size_t x_5; size_t x_6; lean_object* x_7; 
x_5 = lean_unbox_usize(x_2);
lean_dec(x_2);
x_6 = lean_unbox_usize(x_3);
lean_dec(x_3);
x_7 = l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__8(x_1, x_5, x_6, x_4);
lean_dec(x_1);
return x_7;
}
}
LEAN_EXPORT lean_object* l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__12___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3, lean_object* x_4) {
_start:
{
size_t x_5; size_t x_6; lean_object* x_7; 
x_5 = lean_unbox_usize(x_2);
lean_dec(x_2);
x_6 = lean_unbox_usize(x_3);
lean_dec(x_3);
x_7 = l_Array_foldrMUnsafe_fold___at_AgenticAxtell_Baseline_candidateFirms___spec__12(x_1, x_5, x_6, x_4);
lean_dec(x_1);
return x_7;
}
}
LEAN_EXPORT lean_object* l_List_filterTR_loop___at_AgenticAxtell_Baseline_candidateSize___spec__1(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
if (lean_obj_tag(x_2) == 0)
{
lean_object* x_4; 
x_4 = l_List_reverse___rarg(x_3);
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
lean_inc(x_8);
x_9 = lean_nat_dec_eq(x_8, x_1);
lean_dec(x_8);
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
lean_inc(x_14);
x_15 = lean_nat_dec_eq(x_14, x_1);
lean_dec(x_14);
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
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_candidateSize(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; uint8_t x_5; 
x_4 = lean_ctor_get(x_1, 1);
lean_inc(x_4);
x_5 = lean_nat_dec_eq(x_3, x_4);
lean_dec(x_4);
if (x_5 == 0)
{
lean_object* x_6; lean_object* x_7; lean_object* x_8; lean_object* x_9; lean_object* x_10; lean_object* x_11; uint8_t x_12; 
x_6 = lean_ctor_get(x_1, 0);
lean_inc(x_6);
lean_dec(x_1);
x_7 = lean_box(0);
x_8 = l_List_filterTR_loop___at_AgenticAxtell_Baseline_candidateSize___spec__1(x_3, x_6, x_7);
x_9 = lean_unsigned_to_nat(0u);
x_10 = l_List_lengthTRAux___rarg(x_8, x_9);
lean_dec(x_8);
x_11 = lean_ctor_get(x_2, 3);
x_12 = lean_nat_dec_eq(x_3, x_11);
if (x_12 == 0)
{
lean_object* x_13; lean_object* x_14; 
x_13 = lean_unsigned_to_nat(1u);
x_14 = lean_nat_add(x_10, x_13);
lean_dec(x_10);
return x_14;
}
else
{
lean_object* x_15; 
x_15 = lean_nat_add(x_10, x_9);
lean_dec(x_10);
return x_15;
}
}
else
{
lean_object* x_16; 
lean_dec(x_1);
x_16 = lean_unsigned_to_nat(1u);
return x_16;
}
}
}
LEAN_EXPORT lean_object* l_List_filterTR_loop___at_AgenticAxtell_Baseline_candidateSize___spec__1___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l_List_filterTR_loop___at_AgenticAxtell_Baseline_candidateSize___spec__1(x_1, x_2, x_3);
lean_dec(x_1);
return x_4;
}
}
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_candidateSize___boxed(lean_object* x_1, lean_object* x_2, lean_object* x_3) {
_start:
{
lean_object* x_4; 
x_4 = l_AgenticAxtell_Baseline_candidateSize(x_1, x_2, x_3);
lean_dec(x_3);
lean_dec(x_2);
return x_4;
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_BestResponse(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_Baseline_Candidates(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_BestResponse(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_AgenticAxtell_Baseline_candidateFirms___closed__1 = _init_l_AgenticAxtell_Baseline_candidateFirms___closed__1();
lean_mark_persistent(l_AgenticAxtell_Baseline_candidateFirms___closed__1);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
