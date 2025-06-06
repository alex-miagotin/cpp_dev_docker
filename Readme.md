```
.
├── .devcontainer/
│   ├── devcontainer.json
│   └── Dockerfile.dev
|   |__ dev.env
├── docker-compose.yml
├── CMakeLists.txt
├── conanfile.txt
└── src/
    └── main.cpp
```

### 🚀 How to use it

1. Build your dev container:
```
export UID=$(id -u)
export GID=$(id -g)
docker compose --profile dev up --build --remove-orphans --detach
```
2. Open folder in VSCode → it will auto attach to container.

3. In VSCode Terminal:
```
conan profile detect --force
# DEV
conan install . --output-folder=build/dev --build=missing -s build_type=Debug -c tools.cmake.cmaketoolchain:generator=Ninja
cmake --preset=dev
cmake --build --preset=build-dev

# RELEASE
conan install . --output-folder=build/prod --build=missing -s build_type=Release -c tools.cmake.cmaketoolchain:generator=Ninja
cmake --preset=prod
cmake --build --preset=build-prod
```
4. For production build:
```
TODO:
docker compose --profile prod up --build
```

### 📦 TODO: Part 1 — Multi-Arch Docker Build (x86_64 + ARM64)
1. Install buildx (if not yet)
```
docker buildx create --use
docker buildx inspect --bootstrap
```
2. Build multi-arch image
```
docker buildx build --platform linux/amd64,linux/arm64 -t your-image-name:latest .
OR
docker compose --profile prod build
```
- For ARM64, you can even push to DockerHub: --push

