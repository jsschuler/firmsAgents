// Lean compiler output
// Module: AgenticAxtell
// Imports: public import Init public import AgenticAxtell.SemanticRecovery public import AgenticAxtell.Baseline.FixedGroup public import AgenticAxtell.Baseline.LinearBestResponse public import AgenticAxtell.Baseline.LinearStability public import AgenticAxtell.Baseline.NonlinearProduction public import AgenticAxtell.Baseline.NonlinearBestResponse public import AgenticAxtell.Baseline.NonlinearFixedGroup public import AgenticAxtell.Approximation.EffortGrid public import AgenticAxtell.Approximation.FiniteState public import AgenticAxtell.Approximation.FiniteTransition public import AgenticAxtell.Approximation.FiniteKernel public import AgenticAxtell.Approximation.FiniteDynamics public import AgenticAxtell.Approximation.FiniteObservables public import AgenticAxtell.Approximation.Stationary public import AgenticAxtell.Approximation.ChainStructure
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
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_SemanticRecovery(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_FixedGroup(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_LinearBestResponse(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_LinearStability(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearProduction(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearBestResponse(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearFixedGroup(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Approximation_EffortGrid(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteState(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteTransition(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteKernel(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteDynamics(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteObservables(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Approximation_Stationary(uint8_t builtin);
lean_object* initialize_AgenticAxtell_AgenticAxtell_Approximation_ChainStructure(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_AgenticAxtell_AgenticAxtell(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_SemanticRecovery(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_FixedGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_LinearBestResponse(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_LinearStability(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearProduction(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearBestResponse(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Baseline_NonlinearFixedGroup(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Approximation_EffortGrid(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteState(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteTransition(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteKernel(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteDynamics(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Approximation_FiniteObservables(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Approximation_Stationary(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_AgenticAxtell_AgenticAxtell_Approximation_ChainStructure(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
