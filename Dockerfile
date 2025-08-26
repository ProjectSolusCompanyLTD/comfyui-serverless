FROM runpod/worker-comfyui:5.4.0-base
WORKDIR /workspace/ComfyUI

# Copy your custom nodes from the repo into the image
# (Assumes custom_nodes/ exists at repo root)
COPY custom_nodes/ custom_nodes/

# If some custom nodes need extra Python deps, install here:
# RUN pip install --no-cache-dir <package1> <package2>

# Prepare model directories (models mounted at runtime is best)
RUN mkdir -p models/checkpoints models/unet models/rembg models/ipadapter

# Optional: copy tiny required assets (avoid huge model weights in the image)
# COPY models/rembg/BiRefNet.safetensors models/rembg/
