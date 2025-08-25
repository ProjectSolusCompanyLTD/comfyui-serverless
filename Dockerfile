# Lightweight base that already includes ComfyUI + RunPod serverless worker
FROM runpod/worker-comfyui:5.4.0-base

# Work inside the ComfyUI folder used by the worker
WORKDIR /workspace/ComfyUI

# ---- Copy your already-working custom nodes from the repo ----
# Your repo layout should be:
#   /Dockerfile
#   /custom_nodes/<node folders ...>
COPY custom_nodes/ /workspace/ComfyUI/custom_nodes/

# ---- (Optional) clean junk that sometimes gets committed ----
RUN find /workspace/ComfyUI/custom_nodes -name "__pycache__" -type d -exec rm -rf {} + \
 || true

# ---- Install any Python deps the nodes declare (if present) ----
# This auto-discovers requirements*.txt files within your node folders and installs them.
RUN set -e; \
    echo "Scanning for requirements files in custom_nodes..."; \
    find /workspace/ComfyUI/custom_nodes -maxdepth 2 -iname "requirements*.txt" -print \
      -exec pip install --no-cache-dir -r {} \; || true; \
    echo "Custom nodes copied and (if any) requirements installed."

# ---- Create model directories (we'll MOUNT a RunPod Network Volume here) ----
# Keep filenames EXACTLY as your Export(API) workflow expects.
RUN mkdir -p /workspace/ComfyUI/models/checkpoints \
             /workspace/ComfyUI/models/unet \
             /workspace/ComfyUI/models/rembg \
             /workspace/ComfyUI/models/ipadapter

# Nothing else to do: the base image already exposes /run and /runsync for Serverless.
