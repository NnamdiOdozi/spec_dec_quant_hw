# Speculative Decoding + FP8 Quantization Homework Outputs

Generated: 2026-07-02T09:48:14+00:00
Git commit: 09595305c160cff046712b76afcd5681a5a70ffe

## speculative benchmark

```text
# Benchmark metadata
config=speculative
date=2026-07-02T09:15:57+00:00
git_commit=09595305c160cff046712b76afcd5681a5a70ffe
model_for_bench=/home/nnamd/spec_dec_quant_hw/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best
tokenizer_for_bench=Qwen/Qwen3-8B
base_url=http://localhost:8000
dataset_name=hf
dataset_path=philschmid/mt-bench
max_concurrency=8
num_prompts=80

# vLLM bench output
INFO 07-02 09:16:03 [nixl_utils.py:20] Setting UCX_RCACHE_MAX_UNRELEASED to '1024' to avoid a rare memory leak in UCX when using NIXL.
WARNING 07-02 09:16:03 [nixl_utils.py:34] NIXL is not available
WARNING 07-02 09:16:03 [nixl_utils.py:44] NIXL agent config is not available
Warning: You are sending unauthenticated requests to the HF Hub. Please set a HF_TOKEN to enable higher rate limits and faster downloads.
Namespace(subparser='bench', bench_type='serve', dispatch_function=<function BenchmarkServingSubcommand.cmd at 0x77e12f407380>, trust_remote_code=False, seed=0, num_prompts=80, dataset_name='hf', no_stream=False, dataset_path='philschmid/mt-bench', no_oversample=False, skip_chat_template=False, enable_multimodal_chat=False, disable_shuffle=False, custom_output_len=256, spec_bench_output_len=256, spec_bench_category=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, blazedit_min_distance=0.0, blazedit_max_distance=1.0, asr_max_audio_len_sec=inf, asr_min_audio_len_sec=0.0, random_input_len=1024, random_output_len=128, random_range_ratio='0.0', random_prefix_len=0, random_batch_size=1, no_reranker=False, random_mm_base_items_per_request=1, random_mm_num_mm_items_range_ratio=0.0, random_mm_limit_mm_per_prompt={'image': 255, 'video': 1}, random_mm_bucket_config={(256, 256, 1): 0.5, (720, 1280, 1): 0.5, (720, 1280, 16): 0.0}, hf_subset=None, hf_split=None, hf_name=None, hf_output_len=None, prefix_repetition_prefix_len=256, prefix_repetition_suffix_len=256, prefix_repetition_num_prefixes=10, prefix_repetition_output_len=128, speed_bench_dataset_subset='qualitative', speed_bench_output_len=4096, speed_bench_category=None, label=None, backend='openai', base_url='http://localhost:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', header=None, max_concurrency=8, model='/home/nnamd/spec_dec_quant_hw/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best', input_len=None, output_len=None, tokenizer='Qwen/Qwen3-8B', tokenizer_mode='auto', use_beam_search=False, logprobs=None, request_rate=inf, burstiness=1.0, disable_tqdm=False, num_warmups=0, profile=False, save_result=False, save_detailed=False, append_result=False, metadata=None, result_dir=None, result_filename=None, ignore_eos=False, percentile_metrics=None, metric_percentiles='99', goodput=None, request_id_prefix='bench-ef6d33be-', top_p=None, top_k=None, min_p=None, temperature=None, frequency_penalty=None, presence_penalty=None, repetition_penalty=None, served_model_name=None, lora_modules=None, lora_assignment='random', ramp_up_strategy=None, ramp_up_start_rps=None, ramp_up_end_rps=None, ready_check_timeout_sec=0, extra_body=None, skip_tokenizer_init=False, insecure=False, plot_timeline=False, timeline_itl_thresholds='25,50', plot_dataset_stats=False)
WARNING: vllm bench serve no longer sets temperature==0 (greedy) in requests by default. The default will be determined on the server side and can be model/API specific. For the old behavior, include --temperature=0.
Starting initial single prompt test run...
Skipping endpoint ready check.
Starting main benchmark run...
Traffic request rate: inf
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: 8
  0%|          | 0/80 [00:00<?, ?it/s]  1%|▏         | 1/80 [00:01<01:52,  1.43s/it]  9%|▉         | 7/80 [00:01<00:13,  5.55it/s] 11%|█▏        | 9/80 [00:02<00:22,  3.20it/s] 14%|█▍        | 11/80 [00:03<00:16,  4.17it/s] 16%|█▋        | 13/80 [00:03<00:12,  5.21it/s] 21%|██▏       | 17/80 [00:04<00:16,  3.83it/s] 26%|██▋       | 21/80 [00:04<00:09,  5.92it/s] 30%|███       | 24/80 [00:04<00:07,  7.18it/s] 32%|███▎      | 26/80 [00:06<00:12,  4.21it/s] 35%|███▌      | 28/80 [00:06<00:10,  4.89it/s] 41%|████▏     | 33/80 [00:07<00:09,  4.95it/s] 42%|████▎     | 34/80 [00:07<00:10,  4.37it/s] 46%|████▋     | 37/80 [00:07<00:07,  6.09it/s] 50%|█████     | 40/80 [00:07<00:04,  8.03it/s] 52%|█████▎    | 42/80 [00:09<00:08,  4.42it/s] 55%|█████▌    | 44/80 [00:09<00:06,  5.14it/s] 57%|█████▊    | 46/80 [00:09<00:05,  5.87it/s] 60%|██████    | 48/80 [00:09<00:04,  7.06it/s] 62%|██████▎   | 50/80 [00:10<00:06,  4.50it/s] 64%|██████▍   | 51/80 [00:10<00:07,  4.14it/s] 66%|██████▋   | 53/80 [00:10<00:05,  5.34it/s] 68%|██████▊   | 54/80 [00:11<00:04,  5.77it/s] 71%|███████▏  | 57/80 [00:11<00:05,  4.48it/s] 72%|███████▎  | 58/80 [00:11<00:04,  4.80it/s] 74%|███████▍  | 59/80 [00:12<00:04,  4.65it/s] 76%|███████▋  | 61/80 [00:12<00:03,  5.77it/s] 80%|████████  | 64/80 [00:12<00:02,  7.82it/s] 81%|████████▏ | 65/80 [00:13<00:03,  4.33it/s] 82%|████████▎ | 66/80 [00:13<00:02,  4.70it/s] 85%|████████▌ | 68/80 [00:13<00:02,  5.04it/s] 86%|████████▋ | 69/80 [00:14<00:02,  5.27it/s] 89%|████████▉ | 71/80 [00:14<00:01,  6.87it/s] 90%|█████████ | 72/80 [00:14<00:01,  6.68it/s] 91%|█████████▏| 73/80 [00:14<00:01,  4.61it/s] 92%|█████████▎| 74/80 [00:15<00:01,  4.37it/s] 94%|█████████▍| 75/80 [00:15<00:01,  4.21it/s] 95%|█████████▌| 76/80 [00:15<00:00,  4.53it/s] 98%|█████████▊| 78/80 [00:15<00:00,  6.54it/s] 99%|█████████▉| 79/80 [00:15<00:00,  5.99it/s]100%|██████████| 80/80 [00:15<00:00,  6.48it/s]100%|██████████| 80/80 [00:15<00:00,  5.02it/s]
tip: install termplotlib and gnuplot to plot the metrics
============ Serving Benchmark Result ============
Successful requests:                     80        
Failed requests:                         0         
Maximum request concurrency:             8         
Benchmark duration (s):                  15.92     
Total input tokens:                      6078      
Total generated tokens:                  20480     
Request throughput (req/s):              5.02      
Output token throughput (tok/s):         1286.09   
Peak output token throughput (tok/s):    926.00    
Peak concurrent requests:                16.00     
Total token throughput (tok/s):          1667.77   
---------------Time to First Token----------------
Mean TTFT (ms):                          26.88     
Median TTFT (ms):                        26.04     
P99 TTFT (ms):                           35.29     
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          5.94      
Median TPOT (ms):                        6.05      
P99 TPOT (ms):                           6.62      
---------------Inter-token Latency----------------
Mean ITL (ms):                           8.67      
Median ITL (ms):                         8.65      
P99 ITL (ms):                            9.43      
---------------Speculative Decoding---------------
Acceptance rate (%):                     15.36     
Acceptance length:                       1.46      
Drafts:                                  13984     
Draft tokens:                            41952     
Accepted tokens:                         6443      
Per-position acceptance (%):
  Position 0:                            36.18     
  Position 1:                            8.59      
  Position 2:                            1.30      
==================================================
```

## fp8 benchmark

```text
# Benchmark metadata
config=fp8
date=2026-07-02T09:38:20+00:00
git_commit=09595305c160cff046712b76afcd5681a5a70ffe
model_for_bench=/home/nnamd/spec_dec_quant_hw/models/Qwen3-8B-FP8-Dynamic
tokenizer_for_bench=Qwen/Qwen3-8B
base_url=http://localhost:8000
dataset_name=hf
dataset_path=philschmid/mt-bench
max_concurrency=8
num_prompts=80

# vLLM bench output
INFO 07-02 09:38:25 [nixl_utils.py:20] Setting UCX_RCACHE_MAX_UNRELEASED to '1024' to avoid a rare memory leak in UCX when using NIXL.
WARNING 07-02 09:38:25 [nixl_utils.py:34] NIXL is not available
WARNING 07-02 09:38:25 [nixl_utils.py:44] NIXL agent config is not available
Warning: You are sending unauthenticated requests to the HF Hub. Please set a HF_TOKEN to enable higher rate limits and faster downloads.
Namespace(subparser='bench', bench_type='serve', dispatch_function=<function BenchmarkServingSubcommand.cmd at 0x7b5d338031a0>, trust_remote_code=False, seed=0, num_prompts=80, dataset_name='hf', no_stream=False, dataset_path='philschmid/mt-bench', no_oversample=False, skip_chat_template=False, enable_multimodal_chat=False, disable_shuffle=False, custom_output_len=256, spec_bench_output_len=256, spec_bench_category=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, blazedit_min_distance=0.0, blazedit_max_distance=1.0, asr_max_audio_len_sec=inf, asr_min_audio_len_sec=0.0, random_input_len=1024, random_output_len=128, random_range_ratio='0.0', random_prefix_len=0, random_batch_size=1, no_reranker=False, random_mm_base_items_per_request=1, random_mm_num_mm_items_range_ratio=0.0, random_mm_limit_mm_per_prompt={'image': 255, 'video': 1}, random_mm_bucket_config={(256, 256, 1): 0.5, (720, 1280, 1): 0.5, (720, 1280, 16): 0.0}, hf_subset=None, hf_split=None, hf_name=None, hf_output_len=None, prefix_repetition_prefix_len=256, prefix_repetition_suffix_len=256, prefix_repetition_num_prefixes=10, prefix_repetition_output_len=128, speed_bench_dataset_subset='qualitative', speed_bench_output_len=4096, speed_bench_category=None, label=None, backend='openai', base_url='http://localhost:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', header=None, max_concurrency=8, model='/home/nnamd/spec_dec_quant_hw/models/Qwen3-8B-FP8-Dynamic', input_len=None, output_len=None, tokenizer='Qwen/Qwen3-8B', tokenizer_mode='auto', use_beam_search=False, logprobs=None, request_rate=inf, burstiness=1.0, disable_tqdm=False, num_warmups=0, profile=False, save_result=False, save_detailed=False, append_result=False, metadata=None, result_dir=None, result_filename=None, ignore_eos=False, percentile_metrics=None, metric_percentiles='99', goodput=None, request_id_prefix='bench-b078c0d8-', top_p=None, top_k=None, min_p=None, temperature=None, frequency_penalty=None, presence_penalty=None, repetition_penalty=None, served_model_name=None, lora_modules=None, lora_assignment='random', ramp_up_strategy=None, ramp_up_start_rps=None, ramp_up_end_rps=None, ready_check_timeout_sec=0, extra_body=None, skip_tokenizer_init=False, insecure=False, plot_timeline=False, timeline_itl_thresholds='25,50', plot_dataset_stats=False)
WARNING: vllm bench serve no longer sets temperature==0 (greedy) in requests by default. The default will be determined on the server side and can be model/API specific. For the old behavior, include --temperature=0.
Starting initial single prompt test run...
Skipping endpoint ready check.
Starting main benchmark run...
Traffic request rate: inf
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: 8
  0%|          | 0/80 [00:00<?, ?it/s]  1%|▏         | 1/80 [00:01<01:39,  1.27s/it] 11%|█▏        | 9/80 [00:02<00:17,  4.05it/s] 21%|██▏       | 17/80 [00:03<00:12,  5.10it/s] 31%|███▏      | 25/80 [00:05<00:09,  5.58it/s] 41%|████▏     | 33/80 [00:06<00:08,  5.86it/s] 51%|█████▏    | 41/80 [00:07<00:06,  6.02it/s] 61%|██████▏   | 49/80 [00:08<00:05,  6.12it/s] 71%|███████▏  | 57/80 [00:10<00:03,  6.19it/s] 81%|████████▏ | 65/80 [00:11<00:02,  6.24it/s] 91%|█████████▏| 73/80 [00:12<00:01,  6.26it/s]100%|██████████| 80/80 [00:12<00:00,  6.32it/s]
tip: install termplotlib and gnuplot to plot the metrics
============ Serving Benchmark Result ============
Successful requests:                     80        
Failed requests:                         0         
Maximum request concurrency:             8         
Benchmark duration (s):                  12.65     
Total input tokens:                      6078      
Total generated tokens:                  20476     
Request throughput (req/s):              6.32      
Output token throughput (tok/s):         1618.27   
Peak output token throughput (tok/s):    1640.00   
Peak concurrent requests:                16.00     
Total token throughput (tok/s):          2098.63   
---------------Time to First Token----------------
Mean TTFT (ms):                          21.49     
Median TTFT (ms):                        20.93     
P99 TTFT (ms):                           26.14     
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          4.87      
Median TPOT (ms):                        4.87      
P99 TPOT (ms):                           4.90      
---------------Inter-token Latency----------------
Mean ITL (ms):                           4.87      
Median ITL (ms):                         4.87      
P99 ITL (ms):                            5.29      
==================================================
```

## fp8_speculative benchmark

```text
# Benchmark metadata
config=fp8_speculative
date=2026-07-02T09:42:38+00:00
git_commit=09595305c160cff046712b76afcd5681a5a70ffe
model_for_bench=/home/nnamd/spec_dec_quant_hw/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best
tokenizer_for_bench=Qwen/Qwen3-8B
base_url=http://localhost:8000
dataset_name=hf
dataset_path=philschmid/mt-bench
max_concurrency=8
num_prompts=80

# vLLM bench output
INFO 07-02 09:42:44 [nixl_utils.py:20] Setting UCX_RCACHE_MAX_UNRELEASED to '1024' to avoid a rare memory leak in UCX when using NIXL.
WARNING 07-02 09:42:44 [nixl_utils.py:34] NIXL is not available
WARNING 07-02 09:42:44 [nixl_utils.py:44] NIXL agent config is not available
Warning: You are sending unauthenticated requests to the HF Hub. Please set a HF_TOKEN to enable higher rate limits and faster downloads.
Namespace(subparser='bench', bench_type='serve', dispatch_function=<function BenchmarkServingSubcommand.cmd at 0x75e020417380>, trust_remote_code=False, seed=0, num_prompts=80, dataset_name='hf', no_stream=False, dataset_path='philschmid/mt-bench', no_oversample=False, skip_chat_template=False, enable_multimodal_chat=False, disable_shuffle=False, custom_output_len=256, spec_bench_output_len=256, spec_bench_category=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, blazedit_min_distance=0.0, blazedit_max_distance=1.0, asr_max_audio_len_sec=inf, asr_min_audio_len_sec=0.0, random_input_len=1024, random_output_len=128, random_range_ratio='0.0', random_prefix_len=0, random_batch_size=1, no_reranker=False, random_mm_base_items_per_request=1, random_mm_num_mm_items_range_ratio=0.0, random_mm_limit_mm_per_prompt={'image': 255, 'video': 1}, random_mm_bucket_config={(256, 256, 1): 0.5, (720, 1280, 1): 0.5, (720, 1280, 16): 0.0}, hf_subset=None, hf_split=None, hf_name=None, hf_output_len=None, prefix_repetition_prefix_len=256, prefix_repetition_suffix_len=256, prefix_repetition_num_prefixes=10, prefix_repetition_output_len=128, speed_bench_dataset_subset='qualitative', speed_bench_output_len=4096, speed_bench_category=None, label=None, backend='openai', base_url='http://localhost:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', header=None, max_concurrency=8, model='/home/nnamd/spec_dec_quant_hw/outputs/checkpoints/eagle3_qwen3_8b_sharegpt_full_20260701_110123/checkpoint_best', input_len=None, output_len=None, tokenizer='Qwen/Qwen3-8B', tokenizer_mode='auto', use_beam_search=False, logprobs=None, request_rate=inf, burstiness=1.0, disable_tqdm=False, num_warmups=0, profile=False, save_result=False, save_detailed=False, append_result=False, metadata=None, result_dir=None, result_filename=None, ignore_eos=False, percentile_metrics=None, metric_percentiles='99', goodput=None, request_id_prefix='bench-5c7eec41-', top_p=None, top_k=None, min_p=None, temperature=None, frequency_penalty=None, presence_penalty=None, repetition_penalty=None, served_model_name=None, lora_modules=None, lora_assignment='random', ramp_up_strategy=None, ramp_up_start_rps=None, ramp_up_end_rps=None, ready_check_timeout_sec=0, extra_body=None, skip_tokenizer_init=False, insecure=False, plot_timeline=False, timeline_itl_thresholds='25,50', plot_dataset_stats=False)
WARNING: vllm bench serve no longer sets temperature==0 (greedy) in requests by default. The default will be determined on the server side and can be model/API specific. For the old behavior, include --temperature=0.
Starting initial single prompt test run...
Skipping endpoint ready check.
Starting main benchmark run...
Traffic request rate: inf
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: 8
  0%|          | 0/80 [00:00<?, ?it/s]  1%|▏         | 1/80 [00:02<03:16,  2.48s/it]  9%|▉         | 7/80 [00:02<00:21,  3.38it/s] 11%|█▏        | 9/80 [00:03<00:28,  2.52it/s] 15%|█▌        | 12/80 [00:04<00:18,  3.74it/s] 19%|█▉        | 15/80 [00:04<00:12,  5.25it/s] 21%|██▏       | 17/80 [00:05<00:18,  3.36it/s] 24%|██▍       | 19/80 [00:05<00:14,  4.22it/s] 28%|██▊       | 22/80 [00:05<00:09,  6.01it/s] 30%|███       | 24/80 [00:05<00:07,  7.01it/s] 32%|███▎      | 26/80 [00:07<00:14,  3.76it/s] 35%|███▌      | 28/80 [00:07<00:10,  4.81it/s] 40%|████      | 32/80 [00:07<00:06,  7.54it/s] 42%|████▎     | 34/80 [00:08<00:11,  4.07it/s] 45%|████▌     | 36/80 [00:08<00:08,  4.92it/s] 49%|████▉     | 39/80 [00:09<00:06,  6.49it/s] 51%|█████▏    | 41/80 [00:09<00:09,  4.33it/s] 54%|█████▍    | 43/80 [00:10<00:07,  5.03it/s] 55%|█████▌    | 44/80 [00:10<00:06,  5.33it/s] 56%|█████▋    | 45/80 [00:10<00:06,  5.32it/s] 60%|██████    | 48/80 [00:10<00:04,  7.13it/s] 61%|██████▏   | 49/80 [00:11<00:07,  4.24it/s] 64%|██████▍   | 51/80 [00:11<00:06,  4.53it/s] 66%|██████▋   | 53/80 [00:12<00:05,  5.21it/s] 69%|██████▉   | 55/80 [00:12<00:03,  6.58it/s] 71%|███████▏  | 57/80 [00:13<00:05,  4.25it/s] 74%|███████▍  | 59/80 [00:13<00:04,  4.96it/s] 76%|███████▋  | 61/80 [00:13<00:03,  5.64it/s] 79%|███████▉  | 63/80 [00:13<00:02,  6.98it/s] 80%|████████  | 64/80 [00:13<00:02,  6.53it/s] 81%|████████▏ | 65/80 [00:14<00:03,  4.06it/s] 84%|████████▍ | 67/80 [00:14<00:02,  4.71it/s] 85%|████████▌ | 68/80 [00:14<00:02,  4.98it/s] 86%|████████▋ | 69/80 [00:15<00:02,  4.98it/s] 89%|████████▉ | 71/80 [00:15<00:01,  6.60it/s] 90%|█████████ | 72/80 [00:15<00:01,  5.70it/s] 91%|█████████▏| 73/80 [00:15<00:01,  4.81it/s] 92%|█████████▎| 74/80 [00:16<00:01,  4.54it/s] 94%|█████████▍| 75/80 [00:16<00:01,  3.99it/s] 96%|█████████▋| 77/80 [00:16<00:00,  5.87it/s] 98%|█████████▊| 78/80 [00:16<00:00,  6.29it/s] 99%|█████████▉| 79/80 [00:16<00:00,  6.46it/s]100%|██████████| 80/80 [00:17<00:00,  4.31it/s]100%|██████████| 80/80 [00:17<00:00,  4.63it/s]
tip: install termplotlib and gnuplot to plot the metrics
============ Serving Benchmark Result ============
Successful requests:                     80        
Failed requests:                         0         
Maximum request concurrency:             8         
Benchmark duration (s):                  17.27     
Total input tokens:                      6078      
Total generated tokens:                  20480     
Request throughput (req/s):              4.63      
Output token throughput (tok/s):         1185.81   
Peak output token throughput (tok/s):    928.00    
Peak concurrent requests:                16.00     
Total token throughput (tok/s):          1537.73   
---------------Time to First Token----------------
Mean TTFT (ms):                          129.42    
Median TTFT (ms):                        26.20     
P99 TTFT (ms):                           1072.83   
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          5.97      
Median TPOT (ms):                        6.06      
P99 TPOT (ms):                           6.73      
---------------Inter-token Latency----------------
Mean ITL (ms):                           8.69      
Median ITL (ms):                         8.64      
P99 ITL (ms):                            9.54      
---------------Speculative Decoding---------------
Acceptance rate (%):                     15.27     
Acceptance length:                       1.46      
Drafts:                                  14012     
Draft tokens:                            42036     
Accepted tokens:                         6417      
Per-position acceptance (%):
  Position 0:                            35.48     
  Position 1:                            8.83      
  Position 2:                            1.49      
==================================================
```

## baseline benchmark

```text
INFO 07-02 08:45:42 [nixl_utils.py:20] Setting UCX_RCACHE_MAX_UNRELEASED to '1024' to avoid a rare memory leak in UCX when using NIXL.
WARNING 07-02 08:45:42 [nixl_utils.py:34] NIXL is not available
WARNING 07-02 08:45:42 [nixl_utils.py:44] NIXL agent config is not available
Warning: You are sending unauthenticated requests to the HF Hub. Please set a HF_TOKEN to enable higher rate limits and faster downloads.
Namespace(subparser='bench', bench_type='serve', dispatch_function=<function BenchmarkServingSubcommand.cmd at 0x7592340071a0>, trust_remote_code=False, seed=0, num_prompts=80, dataset_name='hf', no_stream=False, dataset_path='philschmid/mt-bench', no_oversample=False, skip_chat_template=False, enable_multimodal_chat=False, disable_shuffle=False, custom_output_len=256, spec_bench_output_len=256, spec_bench_category=None, sonnet_input_len=550, sonnet_output_len=150, sonnet_prefix_len=200, sharegpt_output_len=None, blazedit_min_distance=0.0, blazedit_max_distance=1.0, asr_max_audio_len_sec=inf, asr_min_audio_len_sec=0.0, random_input_len=1024, random_output_len=128, random_range_ratio='0.0', random_prefix_len=0, random_batch_size=1, no_reranker=False, random_mm_base_items_per_request=1, random_mm_num_mm_items_range_ratio=0.0, random_mm_limit_mm_per_prompt={'image': 255, 'video': 1}, random_mm_bucket_config={(256, 256, 1): 0.5, (720, 1280, 1): 0.5, (720, 1280, 16): 0.0}, hf_subset=None, hf_split=None, hf_name=None, hf_output_len=None, prefix_repetition_prefix_len=256, prefix_repetition_suffix_len=256, prefix_repetition_num_prefixes=10, prefix_repetition_output_len=128, speed_bench_dataset_subset='qualitative', speed_bench_output_len=4096, speed_bench_category=None, label=None, backend='openai', base_url='http://localhost:8000', host='127.0.0.1', port=8000, endpoint='/v1/completions', header=None, max_concurrency=8, model='Qwen/Qwen3-8B', input_len=None, output_len=None, tokenizer=None, tokenizer_mode='auto', use_beam_search=False, logprobs=None, request_rate=inf, burstiness=1.0, disable_tqdm=False, num_warmups=0, profile=False, save_result=False, save_detailed=False, append_result=False, metadata=None, result_dir=None, result_filename=None, ignore_eos=False, percentile_metrics=None, metric_percentiles='99', goodput=None, request_id_prefix='bench-70c948bb-', top_p=None, top_k=None, min_p=None, temperature=None, frequency_penalty=None, presence_penalty=None, repetition_penalty=None, served_model_name=None, lora_modules=None, lora_assignment='random', ramp_up_strategy=None, ramp_up_start_rps=None, ramp_up_end_rps=None, ready_check_timeout_sec=0, extra_body=None, skip_tokenizer_init=False, insecure=False, plot_timeline=False, timeline_itl_thresholds='25,50', plot_dataset_stats=False)
WARNING: vllm bench serve no longer sets temperature==0 (greedy) in requests by default. The default will be determined on the server side and can be model/API specific. For the old behavior, include --temperature=0.
Starting initial single prompt test run...
Skipping endpoint ready check.
Starting main benchmark run...
Traffic request rate: inf
Burstiness factor: 1.0 (Poisson process)
Maximum request concurrency: 8
  0%|          | 0/80 [00:00<?, ?it/s]  1%|▏         | 1/80 [00:01<02:22,  1.81s/it] 11%|█▏        | 9/80 [00:03<00:25,  2.83it/s] 21%|██▏       | 17/80 [00:05<00:17,  3.56it/s] 31%|███▏      | 25/80 [00:07<00:14,  3.90it/s] 41%|████▏     | 33/80 [00:09<00:11,  4.10it/s] 51%|█████▏    | 41/80 [00:10<00:09,  4.21it/s] 61%|██████▏   | 49/80 [00:12<00:07,  4.28it/s] 71%|███████▏  | 57/80 [00:14<00:05,  4.33it/s] 81%|████████▏ | 65/80 [00:16<00:03,  4.36it/s] 91%|█████████▏| 73/80 [00:18<00:01,  4.38it/s]100%|██████████| 80/80 [00:18<00:00,  4.41it/s]
tip: install termplotlib and gnuplot to plot the metrics
============ Serving Benchmark Result ============
Successful requests:                     80        
Failed requests:                         0         
Maximum request concurrency:             8         
Benchmark duration (s):                  18.14     
Total input tokens:                      6078      
Total generated tokens:                  20473     
Request throughput (req/s):              4.41      
Output token throughput (tok/s):         1128.40   
Peak output token throughput (tok/s):    1152.00   
Peak concurrent requests:                16.00     
Total token throughput (tok/s):          1463.40   
---------------Time to First Token----------------
Mean TTFT (ms):                          25.90     
Median TTFT (ms):                        26.96     
P99 TTFT (ms):                           28.63     
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          7.01      
Median TPOT (ms):                        7.00      
P99 TPOT (ms):                           7.03      
---------------Inter-token Latency----------------
Mean ITL (ms):                           7.01      
Median ITL (ms):                         7.00      
P99 ITL (ms):                            7.39      
==================================================
```

## Environment fingerprints

### outputs/machine_fingerprint.txt
```text
Date:
Wed Jul  1 09:38:10 UTC 2026

Hostname:
computeinstance-e00z2dkz4fzg601642

User:
nnamd

Project dir:
/home/nnamd/spec_dec_quant_hw

Git commit:
a16a4e8b1e728014b1ba9b43d7b2acf4aa8cc653

Disk:
Filesystem      Size  Used Avail Use% Mounted on
tmpfs            20G  2.3M   20G   1% /run
/dev/vda1       484G   19G  465G   4% /
tmpfs            99G     0   99G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/vda16      881M  258M  562M  32% /boot
/dev/vda15      105M  6.2M   99M   6% /boot/efi
cloud-metadata 1008G   20K 1008G   1% /mnt/cloud-metadata
tmpfs            20G   20K   20G   1% /run/user/1001

GPU:
Wed Jul  1 09:38:10 2026       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 580.159.04             Driver Version: 580.159.04     CUDA Version: 13.0     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA H100 80GB HBM3          On  |   00000000:8D:00.0 Off |                    0 |
| N/A   31C    P0             71W /  700W |       0MiB /  81559MiB |      0%      Default |
|                                         |                        |             Disabled |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+

uv:
uv 0.11.26 (x86_64-unknown-linux-gnu)
```

### outputs/env_speculators_freeze.txt
```text
accelerate==1.14.0
aiohappyeyeballs==2.6.2
aiohttp==3.14.1
aiosignal==1.4.0
annotated-doc==0.0.4
annotated-types==0.7.0
anyio==4.14.1
asttokens==3.0.1
attrs==26.1.0
certifi==2026.6.17
charset-normalizer==3.4.7
click==8.4.2
comm==0.2.3
cuda-bindings==12.9.4
cuda-pathfinder==1.5.5
datasets==4.8.4
debugpy==1.8.21
decorator==5.3.1
dill==0.4.1
distro==1.9.0
executing==2.2.1
filelock==3.29.4
frozenlist==1.8.0
fsspec==2026.2.0
h11==0.16.0
hf-xet==1.5.1
httpcore==1.0.9
httpx==0.28.1
huggingface-hub==1.21.0
idna==3.18
ipykernel==7.3.0
ipython==9.15.0
ipython-pygments-lexers==1.1.1
jedi==0.20.0
jinja2==3.1.6
jiter==0.15.0
jupyter-client==8.9.1
jupyter-core==5.9.1
loguru==0.7.3
markdown-it-py==4.2.0
markupsafe==3.0.3
matplotlib-inline==0.2.2
mdurl==0.1.2
mpmath==1.3.0
multidict==6.7.1
multiprocess==0.70.19
nest-asyncio2==1.7.2
networkx==3.6.1
numpy==2.4.2
nvidia-cublas-cu12==12.8.4.1
nvidia-cuda-cupti-cu12==12.8.90
nvidia-cuda-nvrtc-cu12==12.8.93
nvidia-cuda-runtime-cu12==12.8.90
nvidia-cudnn-cu12==9.10.2.21
nvidia-cufft-cu12==11.3.3.83
nvidia-cufile-cu12==1.13.1.3
nvidia-curand-cu12==10.3.9.90
nvidia-cusolver-cu12==11.7.3.90
nvidia-cusparse-cu12==12.5.8.93
nvidia-cusparselt-cu12==0.7.1
nvidia-nccl-cu12==2.27.5
nvidia-nvjitlink-cu12==12.8.93
nvidia-nvshmem-cu12==3.4.5
nvidia-nvtx-cu12==12.8.90
openai==2.44.0
packaging==26.2
pandas==3.0.4
parso==0.8.7
pexpect==4.9.0
platformdirs==4.10.0
prompt-toolkit==3.0.52
propcache==0.5.2
protobuf==7.35.1
psutil==7.2.2
ptyprocess==0.7.0
pure-eval==0.2.3
pyarrow==24.0.0
pydantic==2.13.4
pydantic-core==2.46.4
pydantic-settings==2.14.2
pygments==2.20.0
python-dateutil==2.9.0.post0
python-dotenv==1.2.2
pyyaml==6.0.3
pyzmq==27.1.0
regex==2026.5.9
requests==2.34.2
rich==15.0.0
safetensors==0.8.0
setuptools==82.0.1
shellingham==1.5.4
six==1.17.0
sniffio==1.3.1
-e file:///home/nnamd/spec_dec_quant_hw/external/speculators
stack-data==0.6.3
sympy==1.14.0
tokenizers==0.22.2
torch==2.10.0
tornado==6.5.7
tqdm==4.67.3
traitlets==5.15.1
transformers==5.6.2
triton==3.6.0
typer==0.25.1
typing-extensions==4.15.0
typing-inspection==0.4.2
urllib3==2.7.0
wcwidth==0.8.1
xxhash==3.8.0
yarl==1.24.2
```

### outputs/env_vllm_freeze.txt
```text
aiohappyeyeballs==2.6.2
aiohttp==3.14.1
aiosignal==1.4.0
annotated-doc==0.0.4
annotated-types==0.7.0
anthropic==0.112.0
anyio==4.14.1
apache-tvm-ffi==0.1.9
astor==0.8.1
asttokens==3.0.1
attrs==26.1.0
blake3==1.0.9
cachetools==7.1.4
cbor2==6.1.2
certifi==2026.6.17
cffi==2.0.0
charset-normalizer==3.4.7
click==8.4.2
cloudpickle==3.1.2
comm==0.2.3
compressed-tensors==0.15.0.1
cryptography==49.0.0
cuda-bindings==13.3.1
cuda-core==1.0.1
cuda-pathfinder==1.5.5
cuda-python==13.3.1
cuda-tile==1.4.0
cuda-toolkit==13.0.2
debugpy==1.8.21
decorator==5.3.1
depyf==0.20.0
detect-installer==0.1.0
dill==0.4.1
diskcache==5.6.3
distro==1.9.0
dnspython==2.8.0
docstring-parser==0.18.0
einops==0.8.2
email-validator==2.3.0
executing==2.2.1
fastapi==0.136.3
fastapi-cli==0.0.27
fastapi-cloud-cli==0.21.0
fastar==0.11.0
fastsafetensors==0.3.2
filelock==3.29.4
flashinfer-cubin==0.6.8.post1
flashinfer-python==0.6.8.post1
frozenlist==1.8.0
fsspec==2026.6.0
gguf==0.19.0
googleapis-common-protos==1.75.0
grpcio==1.81.1
h11==0.16.0
hf-xet==1.5.1
httpcore==1.0.9
httptools==0.8.0
httpx==0.28.1
httpx-sse==0.4.3
huggingface-hub==1.21.0
idna==3.18
ijson==3.5.0
interegular==0.3.3
ipykernel==7.3.0
ipython==9.15.0
ipython-pygments-lexers==1.1.1
jedi==0.20.0
jinja2==3.1.6
jiter==0.15.0
jmespath==1.1.0
jsonschema==4.26.0
jsonschema-specifications==2025.9.1
jupyter-client==8.9.1
jupyter-core==5.9.1
lark==1.2.2
llguidance==1.3.0
llvmlite==0.47.0
lm-format-enforcer==0.11.3
loguru==0.7.3
markdown-it-py==4.2.0
markupsafe==3.0.3
matplotlib-inline==0.2.2
mcp==1.28.1
mdurl==0.1.2
mistral-common==1.11.5
ml-dtypes==0.5.4
model-hosting-container-standards==0.1.16
mpmath==1.3.0
msgspec==0.21.1
multidict==6.7.1
nest-asyncio2==1.7.2
networkx==3.6.1
ninja==1.13.0
numba==0.65.0
numpy==2.3.5
nvidia-cublas==13.1.0.3
nvidia-cuda-cupti==13.0.85
nvidia-cuda-nvrtc==13.0.88
nvidia-cuda-runtime==13.0.96
nvidia-cudnn-cu13==9.19.0.56
nvidia-cudnn-frontend==1.18.0
nvidia-cufft==12.0.0.61
nvidia-cufile==1.15.1.6
nvidia-curand==10.4.0.35
nvidia-cusolver==12.0.4.66
nvidia-cusparse==12.6.3.3
nvidia-cusparselt-cu13==0.8.0
nvidia-cutlass-dsl==4.5.2
nvidia-cutlass-dsl-libs-base==4.5.2
nvidia-ml-py==13.610.43
nvidia-nccl-cu13==2.28.9
nvidia-nvjitlink==13.0.88
nvidia-nvshmem-cu13==3.4.5
nvidia-nvtx==13.0.85
openai==2.44.0
openai-harmony==0.0.8
opencv-python-headless==4.13.0.92
opentelemetry-api==1.43.0
opentelemetry-exporter-otlp==1.43.0
opentelemetry-exporter-otlp-proto-common==1.43.0
opentelemetry-exporter-otlp-proto-grpc==1.43.0
opentelemetry-exporter-otlp-proto-http==1.43.0
opentelemetry-proto==1.43.0
opentelemetry-sdk==1.43.0
opentelemetry-semantic-conventions==0.64b0
opentelemetry-semantic-conventions-ai==0.5.1
outlines-core==0.2.14
packaging==26.2
parso==0.8.7
partial-json-parser==0.2.1.1.post7
pexpect==4.9.0
pillow==12.2.0
platformdirs==4.10.0
prometheus-client==0.25.0
prometheus-fastapi-instrumentator==8.0.2
prompt-toolkit==3.0.52
propcache==0.5.2
protobuf==7.35.1
psutil==7.2.2
ptyprocess==0.7.0
pure-eval==0.2.3
py-cpuinfo==9.0.0
pybase64==1.4.3
pycountry==26.2.16
pycparser==3.0
pydantic==2.13.4
pydantic-core==2.46.4
pydantic-extra-types==2.11.1
pydantic-settings==2.14.2
pygments==2.20.0
pyjwt==2.13.0
python-dateutil==2.9.0.post0
python-dotenv==1.2.2
python-json-logger==4.1.0
python-multipart==0.0.32
pyyaml==6.0.3
pyzmq==27.1.0
quack-kernels==0.5.0
referencing==0.37.0
regex==2026.5.9
requests==2.34.2
rich==15.0.0
rich-toolkit==0.20.1
rignore==0.7.6
rpds-py==2026.5.1
safetensors==0.8.0
sentencepiece==0.2.1
sentry-sdk==2.63.0
setproctitle==1.3.7
setuptools==80.10.2
shellingham==1.5.4
six==1.17.0
sniffio==1.3.1
sse-starlette==3.4.5
stack-data==0.6.3
starlette==1.3.1
supervisor==4.3.0
sympy==1.14.0
tabulate==0.10.0
tiktoken==0.13.0
tilelang==0.1.9
tokenizers==0.22.2
torch==2.11.0
torch-c-dlpack-ext==0.1.5
torchaudio==2.11.0
torchvision==0.26.0
tornado==6.5.7
tqdm==4.68.3
traitlets==5.15.1
transformers==5.12.1
triton==3.6.0
typer==0.25.1
typing-extensions==4.15.0
typing-inspection==0.4.2
urllib3==2.7.0
uvicorn==0.49.0
uvloop==0.22.1
vllm==0.20.0
watchfiles==1.2.0
wcwidth==0.8.1
websockets==16.0
xgrammar==0.2.3
yarl==1.24.2
z3-solver==4.15.4.0
```

### outputs/env_compressor_freeze.txt
```text
accelerate==1.13.0
aiohappyeyeballs==2.6.2
aiohttp==3.14.1
aiosignal==1.4.0
annotated-doc==0.0.4
annotated-types==0.7.0
anyio==4.14.1
asttokens==3.0.1
attrs==26.1.0
auto-round==0.13.0
certifi==2026.6.17
charset-normalizer==3.4.7
click==8.4.2
comm==0.2.3
compressed-tensors==0.17.1
cuda-bindings==13.3.1
cuda-pathfinder==1.5.5
cuda-toolkit==13.0.2
datasets==5.0.0
debugpy==1.8.21
decorator==5.3.1
dill==0.4.1
executing==2.2.1
filelock==3.29.4
frozenlist==1.8.0
fsspec==2026.4.0
h11==0.16.0
hf-xet==1.5.1
httpcore==1.0.9
httpx==0.28.1
huggingface-hub==1.21.0
idna==3.18
ipykernel==7.3.0
ipython==9.15.0
ipython-pygments-lexers==1.1.1
jedi==0.20.0
jinja2==3.1.6
jupyter-client==8.9.1
jupyter-core==5.9.1
llmcompressor==0.12.0
loguru==0.7.3
markdown-it-py==4.2.0
markupsafe==3.0.3
matplotlib-inline==0.2.2
mdurl==0.1.2
mpmath==1.3.0
multidict==6.7.1
multiprocess==0.70.19
nest-asyncio2==1.7.2
networkx==3.6.1
numpy==2.4.6
nvidia-cublas==13.1.1.3
nvidia-cuda-cupti==13.0.85
nvidia-cuda-nvrtc==13.0.88
nvidia-cuda-runtime==13.0.96
nvidia-cudnn-cu13==9.20.0.48
nvidia-cufft==12.0.0.61
nvidia-cufile==1.15.1.6
nvidia-curand==10.4.0.35
nvidia-cusolver==12.0.4.66
nvidia-cusparse==12.6.3.3
nvidia-cusparselt-cu13==0.8.1
nvidia-ml-py==13.610.43
nvidia-nccl-cu13==2.29.7
nvidia-nvjitlink==13.0.88
nvidia-nvshmem-cu13==3.4.5
nvidia-nvtx==13.0.85
packaging==26.2
pandas==3.0.4
parso==0.8.7
pexpect==4.9.0
pillow==12.2.0
platformdirs==4.10.0
prompt-toolkit==3.0.52
propcache==0.5.2
psutil==7.2.2
ptyprocess==0.7.0
pure-eval==0.2.3
py-cpuinfo==9.0.0
pyarrow==24.0.0
pydantic==2.13.4
pydantic-core==2.46.4
pygments==2.20.0
python-dateutil==2.9.0.post0
pyyaml==6.0.3
pyzmq==27.1.0
regex==2026.5.9
requests==2.34.2
rich==15.0.0
safetensors==0.8.0
setuptools==81.0.0
shellingham==1.5.4
six==1.17.0
stack-data==0.6.3
sympy==1.14.0
tokenizers==0.22.2
torch==2.12.0
tornado==6.5.7
tqdm==4.68.2
traitlets==5.15.1
transformers==5.10.1
triton==3.7.0
typer==0.25.1
typing-extensions==4.15.0
typing-inspection==0.4.2
urllib3==2.7.0
wcwidth==0.8.1
xxhash==3.8.0
yarl==1.24.2
```

### outputs/nvidia_smi.txt
```text
Wed Jul  1 09:39:47 2026       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 580.159.04             Driver Version: 580.159.04     CUDA Version: 13.0     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA H100 80GB HBM3          On  |   00000000:8D:00.0 Off |                    0 |
| N/A   31C    P0             73W /  700W |       0MiB /  81559MiB |      0%      Default |
|                                         |                        |             Disabled |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+
```

### outputs/git_commit.txt
```text
a16a4e8b1e728014b1ba9b43d7b2acf4aa8cc653
```

### outputs/disk_space.txt
```text
Filesystem      Size  Used Avail Use% Mounted on
tmpfs            20G  2.4M   20G   1% /run
/dev/vda1       484G   36G  448G   8% /
tmpfs            99G     0   99G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/vda16      881M  258M  562M  32% /boot
/dev/vda15      105M  6.2M   99M   6% /boot/efi
cloud-metadata 1008G   20K 1008G   1% /mnt/cloud-metadata
tmpfs            20G   20K   20G   1% /run/user/1001
```

