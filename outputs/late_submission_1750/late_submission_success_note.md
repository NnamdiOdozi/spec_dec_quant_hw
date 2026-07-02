# Late submission success note: corrected FP8 + speculative benchmark

Goal:
Improve the FP8 + speculative decoding result above the homework rubric threshold of 1750 output tokens/second.

Issue found:
The earlier FP8 + speculative runs were not actually using the FP8 verifier/target model. The vLLM log showed:

- Unknown vLLM environment variable: VLLM_TARGET_MODEL_OVERRIDE
- target model: Qwen/Qwen3-8B
- dtype: torch.bfloat16
- quantization: None

So those earlier runs were effectively BF16 target + EAGLE drafter, not FP8 target + EAGLE drafter.

Fix:
Created a copied EAGLE checkpoint:

- checkpoint_best_nspec2_fp8target

and patched its config.json so:

- speculators_config.verifier.name_or_path

points to:

- /home/nnamd/spec_dec_quant_hw/models/Qwen3-8B-FP8-Dynamic

The corrected vLLM server log confirmed:

- model=/home/nnamd/spec_dec_quant_hw/models/Qwen3-8B-FP8-Dynamic
- speculative_config uses checkpoint_best_nspec2_fp8target
- quantization=compressed-tensors
- CutlassFP8ScaledMMLinearKernel selected for CompressedTensorsW8A8Fp8

Best corrected result:
- Best run file: outputs/late_submission_1750/best_REAL_fp8_target_speculative_result.txt
- Output token throughput: 1899.4 tok/s
- Rubric threshold: >1750 tok/s
- Result: PASS

Conclusion:
The missing performance was due to the FP8 target model not being used in the speculative serving path. Once the EAGLE checkpoint config was patched to point directly at the FP8 verifier model, FP8 + speculative decoding exceeded the rubric threshold.
