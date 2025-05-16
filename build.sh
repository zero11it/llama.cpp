#!/bin/sh
version=server-b5401

git clone https://github.com/ggml-org/llama.cpp llama-cpp
(cd llama-cpp && git checkout b5401)

sed -i 's/build-essential cmake/build-essential libssl-dev libcrypto++-dev cmake/' llama-cpp/.devops/cuda.Dockerfile
sed -i 's/-DGGML_CUDA=ON -DGGML/-DGGML_CUDA=ON -DLLAMA_SERVER_SSL=ON -DGGML/' llama-cpp/.devops/cuda.Dockerfile
sed -i 's/libgomp1 curl/libgomp1 libssl3 libcrypto++8 curl/' llama-cpp/.devops/cuda.Dockerfile
sed -i '/COPY start.sh \/app\//d' llama-cpp/.devops/cuda.Dockerfile
sed -i '/ENTRYPOINT \[\"\/app\/start\.sh\"\]/d' llama-cpp/.devops/cuda.Dockerfile
echo "COPY start.sh /app/" >> llama-cpp/.devops/cuda.Dockerfile
echo "ENTRYPOINT [\"/app/start.sh\"]" >> llama-cpp/.devops/cuda.Dockerfile
cp start.sh llama-cpp/

(cd llama-cpp && docker buildx build --provenance=false --sbom=false --platform linux/amd64 -f .devops/cuda.Dockerfile --push --tag ghcr.io/zero11it/llama.cpp:$version . \
     && docker buildx build --platform linux/amd64 -f .devops/cuda.Dockerfile --push --tag registry.zero11.org/zero11/llama.cpp:$version .)
