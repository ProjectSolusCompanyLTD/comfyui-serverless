FROM runpod/worker-comfyui:5.4.0-base
WORKDIR /workspace/ComfyUI

# ---- Custom nodes (examples; replace with YOURS) ----
RUN --mount=type=cache,target=/root/.cache \
    git clone --depth=1 https://github.com/Vanillaua/ComfyUI-BiRefNet custom_nodes/BiRefNet && \
    git clone --depth=1 https://github.com/cubiq/ComfyUI_IPAdapter_plus custom_nodes/IPAdapterPlus && \
    git clone --depth=1 https://github.com/ltdrdata/ComfyUI-Impact-Pack custom_nodes/ImpactPack && \
    git clone --depth=1 https://github.com/lllyasviel/IC-Light custom_nodes/IC-Light && \
    git clone --depth=1 https://github.com/GeorgLegato/ComfyUI-IC-Light-Integration custom_nodes/ICLightIntegration

# If some nodes require extra Python deps, add them here:
# RUN pip install <package1> <package2>

# ---- Models ----
# Prefer NOT to bake large models. Instead, mount a RunPod Network Volume
# to /workspace/ComfyUI/models when you create the endpoint.
RUN mkdir -p models/checkpoints models/unet models/rembg models/ipadapter
# If you *must* bake small/critical files, add COPY lines (keep sizes small):
# COPY models/checkpoints/epicphotogasm_ultimateFidelity.safetensors models/checkpoints/
# COPY models/unet/iclight_sd15_fc.safetensors models/unet/
# COPY models/rembg/BiRefNet.safetensors models/rembg/
