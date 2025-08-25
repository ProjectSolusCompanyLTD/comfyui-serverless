FROM runpod/worker-comfyui:5.4.0-base
WORKDIR /workspace/ComfyUI

# copy your nodes
COPY custom_nodes/ /workspace/ComfyUI/custom_nodes/

# no pip cache & smaller layers
ENV PIP_NO_CACHE_DIR=1
RUN find /workspace/ComfyUI/custom_nodes -name "__pycache__" -type d -exec rm -rf {} + || true

# install any requirements*.txt found in your nodes (you said you need them all)
RUN set -e; \
    echo "Installing custom node requirements..."; \
    f_list=$(find /workspace/ComfyUI/custom_nodes -maxdepth 2 -iname "requirements*.txt" -print); \
    for f in $f_list; do echo "==> $f"; pip install --no-cache-dir -r "$f"; done; \
    python - <<'PY'
import pkgutil, sys
print("Installed packages:", len(list(pkgutil.iter_modules())))
PY

# model dirs (you will mount a RunPod volume here)
RUN mkdir -p /workspace/ComfyUI/models/checkpoints \
             /workspace/ComfyUI/models/unet \
             /workspace/ComfyUI/models/rembg \
             /workspace/ComfyUI/models/ipadapter
