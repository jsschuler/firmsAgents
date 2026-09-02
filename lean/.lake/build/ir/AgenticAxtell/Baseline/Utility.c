// Lean compiler output
// Module: AgenticAxtell.Baseline.Utility
// Imports: Init AgenticAxtell.Baseline.Production
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
LEAN_EXPORT lean_object* l_AgenticAxtell_Baseline_FeasibleEffort;
static lean_object* _init_l_AgenticAxtell_Baseline_FeasibleEffort() {
_start:
{
return lean_box(0);
}
}
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_AgenticAxtell_Baseline_Production(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_Baseline_Utility(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_Baseline_Production(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
l_AgenticAxtell_Baseline_FeasibleEffort = _init_l_AgenticAxtell_Baseline_FeasibleEffort();
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
