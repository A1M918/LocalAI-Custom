import torch
import time

print("=== ROCm rocBLAS Test ===")
print(f"PyTorch version: {torch.__version__}")
print(f"ROCm available: {torch.cuda.is_available()}")
print(f"Device: {torch.cuda.get_device_name(0)}")
print(f"VRAM: {torch.cuda.get_device_properties(0).total_memory/1024**3:.1f}GB")

# Test matrix multiplication
print("\nTesting matrix multiplication...")
a = torch.randn(2048, 2048, device='cuda')
b = torch.randn(2048, 2048, device='cuda')

# Warmup
c = a @ b
torch.cuda.synchronize()

# Benchmark
start = time.time()
c = a @ b
torch.cuda.synchronize()
end = time.time()

print(f"2048x2048 matrix multiplication time: {(end-start)*1000:.2f} ms")
print("✓ rocBLAS is working!")
