FROM rocm/pytorch:rocm5.7_ubuntu22.04_py3.10_pytorch_2.0.1

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    p7zip-full \
    && rm -rf /var/lib/apt/lists/*

# Download and install custom rocBLAS for gfx906 (MI50)
RUN wget -q https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU/releases/download/v0.5.7/rocblas.for.gfx906.7z && \
    7z x rocblas.for.gfx906.7z -orocblas-extracted && \
    mkdir -p /opt/rocm/lib/rocblas/library.original && \
    if [ -d "/opt/rocm/lib/rocblas/library" ]; then \
        mv /opt/rocm/lib/rocblas/library/* /opt/rocm/lib/rocblas/library.original/ 2>/dev/null || true; \
        rm -rf /opt/rocm/lib/rocblas/library; \
    fi && \
    mkdir -p /opt/rocm/lib/rocblas/library && \
    cp -r rocblas-extracted/library/* /opt/rocm/lib/rocblas/library/ && \
    rm -rf rocblas.for.gfx906.7z rocblas-extracted

# Set environment variables
ENV ROCBLAS_TENSILE_LIBPATH=/opt/rocm/lib/rocblas/library \
    HCC_AMDGPU_TARGET=gfx906

# Create workspace directory
RUN mkdir -p /workspace

WORKDIR /workspace
CMD ["/bin/bash"]
