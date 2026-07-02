# Task 2 summary: EAGLE-3 speculator training

Task:
Train an EAGLE-3 draft/speculator model using the prepared ShareGPT dataset and hidden states from Qwen/Qwen3-8B.

Base/verifier model:
- Qwen/Qwen3-8B

Training data:
- outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123

Hidden states:
- outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123/hidden_states

Checkpoint directory:
- outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123

Best checkpoint:
- outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best

Result:
- Training completed successfully.
- Training ran for 5 epochs.
- Best checkpoint was saved.

Final validation metrics:
- val/loss_epoch: 10.861
- val/full_acc_0_epoch: 0.464
- val/full_acc_1_epoch: 0.182
- val/full_acc_2_epoch: 0.069
- val/cond_acc_0_epoch: 0.464
- val/cond_acc_1_epoch: 0.365
- val/cond_acc_2_epoch: 0.323

Evidence:
- logs/train_eagle3_20260701_112537.log
- outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best
- outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/4/val_metrics.json

Notes:
The trained checkpoint was later served through vLLM as the EAGLE/speculative configuration. The later benchmark showed a low acceptance rate of about 15%, which explains why speculative decoding improved throughput only modestly.
