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
```
USER_UID=$(id -u) USER_GID=$(id -g) docker compose --profile dev up --build --remove-orphans --detach
```
```
npm install -g @devcontainers/cli
devcontainer up --workspace-folder .
code --folder-uri "vscode-remote://attached-container+%dev_container%/workspace"
```
```
# vscode issue
[72 ms] Start: Resolving Remote
[83 ms] TypeError: Cannot read properties of undefined (reading 'parentAuthority')

# solution
sudo snap remove code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
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

### Useful commands
- `docker-compose ps`
- `docker-compose logs`
- `docker-compose down --remove-orphans`

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

