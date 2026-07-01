Below is a handoff note you can paste into something like:

```bash
notes/agent_handoff_20260701.md
```

or:

```bash
outputs/agent_handoff_20260701.md
```

---

# Handoff note — Speculative Decoding / EAGLE-3 homework

We are working in the GPU VM project directory:

```bash
/home/nnamd/spec_dec_quant_hw
```

The assignment appears to involve speculative decoding and quantization. So far, the main work completed is the EAGLE-3 data preparation and training flow for `Qwen/Qwen3-8B`. The local coding agents have not been involved in writing the existing scripts, so please treat the current repo state, run logs, and outputs as the source of truth rather than assuming prior context.

The important project folders are:

```bash
scripts/
outputs/
logs/
external/speculators/
speculators_venv/
vllm_venv/
compressor_venv/
```

The main scripts involved so far are:

```bash
scripts/prepare_eagle_data.sh
scripts/train_eagle3.sh
scripts/upload_artifacts.sh
scripts/serve_vllm.sh
scripts/bench_vllm.sh
scripts/collect_submission_outputs.sh
```

## What has been completed

### Task 1 — EAGLE-3 hidden-state data preparation

This task has completed successfully.

The full prepared dataset is here:

```bash
/home/nnamd/spec_dec_quant_hw/outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123
```

The hidden states are here:

```bash
/home/nnamd/spec_dec_quant_hw/outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123/hidden_states
```

The run prepared 3,000 samples. The final log excerpt showed:

```text
Saved 3000 new data points
Data generation complete!
Disk after hidden-state generation: 122G
```

The log file is:

```bash
/home/nnamd/spec_dec_quant_hw/logs/prepare_eagle_data_20260701_110123.log
```

Please verify before using the dataset:

```bash
cd /home/nnamd/spec_dec_quant_hw

DATA_DIR="$PWD/outputs/eagle3_qwen3_8b_sharegpt_full_20260701_110123"
HIDDEN_STATES_DIR="$DATA_DIR/hidden_states"

du -sh "$DATA_DIR"
find "$HIDDEN_STATES_DIR" -type f | wc -l
find "$HIDDEN_STATES_DIR" -type f -size 0 | wc -l
```

Expected:

```text
Dataset size: about 122G
Hidden-state file count: 3000
Zero-byte hidden-state files: 0
```

There were earlier failed or partial runs. They were moved into an `_partial_failed_runs` folder. Do not use those partial folders for training. The successful smoke test is also present, but it is not the full dataset:

```bash
outputs/smoke_eagle3_seq1000_20260701_104338
```

That has 50 hidden-state files and is only useful as a sanity check.

Important note: the `output` folder is a symlink to `outputs`:

```bash
output -> outputs
```

So use `outputs/` as the canonical path.

### Important script patch already made

`prepare_eagle_data.sh` was patched so that the vLLM server max context length is not equal to the data sequence length. The relevant logic is:

```bash
VLLM_MAX_MODEL_LEN="${VLLM_MAX_MODEL_LEN:-$((SEQ_LENGTH + 64))}"
```

This matters because the hidden-state generation request uses:

```text
input tokens + 1 output token
```

So if `SEQ_LENGTH=2048`, vLLM needs more than 2048 context tokens. Do not remove this patch.

## Task 2 — EAGLE-3 draft/speculator training

This task has also completed successfully.

The training command used the full prepared dataset explicitly, because the default `DATA_DIR` in `scripts/train_eagle3.sh` points to the old default path:

```bash
DATA_DIR="${DATA_DIR:-$ROOT/outputs/eagle3_qwen3_8b_sharegpt}"
```

That default path should not be trusted for this run. The training was run with the full dataset path.

The training log is:

```bash
/home/nnamd/spec_dec_quant_hw/logs/train_eagle3_20260701_112537.log
```

The checkpoint directory is:

```bash
/home/nnamd/spec_dec_quant_hw/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123
```

The best checkpoint symlink is:

```bash
/home/nnamd/spec_dec_quant_hw/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best
```

It resolves to epoch/checkpoint `4`:

```bash
/home/nnamd/spec_dec_quant_hw/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/4
```

Verification already showed the best checkpoint contains:

```text
config.json
config.py
model.safetensors
optimizer_state_dict.pt
scheduler_state_dict.pt
val_metrics.json
```

The full checkpoint run folder is about 15G. The best checkpoint is about 3G including optimizer state.

The final training log showed:

```text
Training complete
checkpoint_best -> 4
```

Validation metrics from the final epoch included approximately:

```text
val/loss_epoch=10.861
val/full_acc_0_epoch=0.464
val/full_acc_1_epoch=0.182
val/full_acc_2_epoch=0.069
```

Please do not infer too much from those metrics without reading the homework requirements. They mainly confirm that training ran and produced a checkpoint.

## Artifact upload status

The trained best checkpoint and run artifacts have been uploaded to both Hugging Face and Weights & Biases.

Hugging Face model repo used:

```text
nodozi/eagle3-qwen3-8b-sharegpt
```

W&B entity and project used:

```text
Entity:  team-ave
Project: spec-dec-quant-hw
```

The upload script is:

```bash
scripts/upload_artifacts.sh
```

It has been patched with a usage/comment block at the top explaining the known working HF repo, W&B entity, and W&B project. Tokens are not stored in the script. They should remain in `.env`:

```bash
HF_TOKEN=...
WANDB_API_KEY=...
```

Useful upload command examples:

```bash
UPLOAD_TO_HF=1 UPLOAD_TO_WANDB=1 bash scripts/upload_artifacts.sh
```

or W&B only:

```bash
UPLOAD_TO_HF=0 UPLOAD_TO_WANDB=1 bash scripts/upload_artifacts.sh
```

Do not upload the 122G hidden-state dataset unless explicitly needed. The script defaults to:

```bash
INCLUDE_DATA=0
```

## What remains to do

We have not yet started Task 3. The next likely stage is to serve and benchmark:

1. baseline vLLM serving;
2. speculative serving using the trained EAGLE checkpoint;
3. possibly FP8 serving;
4. possibly FP8 + speculative serving;
5. collect logs/results for the homework notebook or final submission.

Relevant scripts:

```bash
scripts/serve_vllm.sh
scripts/bench_vllm.sh
scripts/collect_submission_outputs.sh
```

Before running speculative serving, ensure `DRAFT_CHECKPOINT` points to the real trained checkpoint:

```bash
BEST_CKPT="$PWD/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best"
```

Do not rely on the default in `serve_vllm.sh`, because grep showed:

```bash
DRAFT_CHECKPOINT="${DRAFT_CHECKPOINT:-$ROOT/outputs/checkpoints/checkpoint_best}"
```

That is not the correct path for this run.

Likely next command pattern:

```bash
cd /home/nnamd/spec_dec_quant_hw

BEST_CKPT="$PWD/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best"

DRAFT_CHECKPOINT="$BEST_CKPT" \
bash scripts/serve_vllm.sh speculative
```

Then benchmark with:

```bash
bash scripts/bench_vllm.sh speculative
```

But before executing Task 3, inspect `serve_vllm.sh` carefully. It may incorrectly treat the EAGLE checkpoint as the main model rather than as a speculative draft/speculator argument. If serving fails, immediately inspect:

```bash
tail -200 logs/vllm_serve_*.log 2>/dev/null || true
tmux capture-pane -t vllm-serve -p | tail -200
nl -ba scripts/serve_vllm.sh | sed -n '1,140p'
```

## What results need collecting

The final homework evidence should probably include:

```bash
outputs/latest_full_prepared_dataset.txt
outputs/latest_eagle3_checkpoint.txt
logs/prepare_eagle_data_20260701_110123.log
logs/train_eagle3_20260701_112537.log
outputs/upload_manifests/
outputs/env_speculators_freeze.txt
outputs/env_vllm_freeze.txt
outputs/nvidia_smi.txt
outputs/python_versions.txt
outputs/git_commit.txt
```

After Task 3 benchmarking, also collect:

```bash
outputs/benchmarks/
logs/vllm_serve_*.log
```

The script `scripts/collect_submission_outputs.sh` appears intended to gather final outputs. Inspect it before running, then use it to generate a submission bundle if appropriate.

Final caution: the GPU VM currently has large local artifacts. The prepared hidden-state dataset is 122G, and checkpoints are around 15G. Do not sync all of `outputs/` back to the laptop. Only copy logs, manifests, benchmark summaries, notebook outputs, and final small reports unless the model artifacts are specifically needed locally.
