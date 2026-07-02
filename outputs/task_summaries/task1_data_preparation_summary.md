# Task 1 summary: EAGLE hidden-state data preparation

Task:
Prepare a ShareGPT-based EAGLE-3 training dataset and generate hidden states using the Qwen/Qwen3-8B verifier model.

Main model:
- Qwen/Qwen3-8B

Dataset/output directory:
- outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123

Hidden-state directory:
- outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123/hidden_states

Result:
- Data preparation completed successfully.
- 3000 samples were prepared.
- 3000 hidden-state files were generated.
- Hidden-state directory size was approximately 122 GB.

Key settings:
- Sequence length: 2048
- vLLM max model length: sequence length + 64
- Hidden-state extraction server ran through vLLM.
- Concurrency: 32

Evidence:
- logs/prepare_eagle_data_20260701_110123.log
- outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123
- outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123/hidden_states

Notes:
This task created the training data used by the EAGLE/speculator training step. The hidden-state dataset is large and should not normally be copied back to the local laptop unless specifically required.
