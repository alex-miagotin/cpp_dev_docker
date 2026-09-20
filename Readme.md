# C++ Dev Container

A ready-to-use **C++20 development environment in Docker**: Ubuntu, a current CMake, clang tooling, Conan and Ninja, wired to VS Code through Dev Containers. Clone it, start the container, and build a Conan + CMake project without installing a toolchain on the host.

![C++20](https://img.shields.io/badge/C%2B%2B-20-00599C?logo=cplusplus&logoColor=white)
![CMake](https://img.shields.io/badge/build-CMake%20%2B%20Ninja-064F8C?logo=cmake&logoColor=white)
![Conan](https://img.shields.io/badge/deps-Conan%202-6699CB?logo=conan&logoColor=white)
![Docker](https://img.shields.io/badge/env-Docker%20Compose-2496ED?logo=docker&logoColor=white)

## Contents

- [What is inside](#what-is-inside)
- [Repository layout](#repository-layout)
- [Quick start](#quick-start)
- [Build the sample project](#build-the-sample-project)
- [Use it for your own project](#use-it-for-your-own-project)
- [Useful commands](#useful-commands)
- [Troubleshooting](#troubleshooting)
- [Roadmap](#roadmap)

## What is inside

| Component | Details |
|---|---|
| Base image | Ubuntu 22.04 |
| Compilers and build | `g++` / `gcc`, `build-essential`, Ninja, CMake from the Kitware apt repository |
| Clang tooling | LLVM 19 with `clangd` (symlinked to `/usr/bin/clangd`) |
| Dependencies | Conan 2 (installed with pip); the sample uses `fmt` |
| Editor | VS Code Dev Container with clangd, CodeLLDB, CMake Tools and Docker extensions |
| User | A non-root user that matches your host UID and GID, with passwordless `sudo` |
| Mounts | The repository at `/workspace`, and your host `~/.conan` cache |

## Repository layout

```
.
├── .devcontainer/
│   ├── devcontainer.json   # VS Code Dev Container definition
│   ├── Dockerfile.dev      # image with the toolchain
│   └── dev.env             # user and group passed into the container
├── docker-compose.yml      # the `dev` service
├── CMakeLists.txt          # sample project
├── CMakePresets.json       # `dev` (Debug) and `prod` (Release) presets
├── conanfile.txt           # sample dependency: fmt
├── scripts/build.sh        # dev build in one command
└── src/main.cpp            # hello-world using fmt
```

## Quick start

Prerequisites: Docker with the Compose plugin, and VS Code with the Dev Containers extension (or the Dev Containers CLI).

**1. Start the container**

```bash
USER_UID=$(id -u) USER_GID=$(id -g) docker compose --profile dev up --build --remove-orphans --detach
```

The container is named `dev_container`. Passing `USER_UID` and `USER_GID` makes files created inside it belong to your host user.

**2. Attach an editor**

- **VS Code:** open the folder and choose *Reopen in Container*; it attaches to the running service.
- **Dev Containers CLI:**
  ```bash
  npm install -g @devcontainers/cli
  devcontainer up --workspace-folder .
  code --folder-uri "vscode-remote://attached-container+dev_container/workspace"
  ```

**3. Work in the container terminal.** The workspace is `/workspace`.

## Build the sample project

Inside the container:

```bash
conan profile detect --force

# Debug
conan install . --output-folder=build/dev --build=missing -s build_type=Debug -c tools.cmake.cmaketoolchain:generator=Ninja
cmake --preset=dev
cmake --build --preset=build-dev

# Release
conan install . --output-folder=build/prod --build=missing -s build_type=Release -c tools.cmake.cmaketoolchain:generator=Ninja
cmake --preset=prod
cmake --build --preset=build-prod
```

`scripts/build.sh` runs the Debug sequence. The executable is written to `build/<preset>/bin/`, for example `build/dev/bin/hello_cpp`.

## Use it for your own project

The sample is a template. Its project and executable are both named `hello_cpp`; rename them for your project:

- In `CMakeLists.txt`, change `project(hello_cpp)` and the `hello_cpp` target.
- In `.vscode/launch.json`, update the debug configuration's `program` path.
- In `scripts/build.sh`, update the path in the trailing comment.
- Add your dependencies to `conanfile.txt`.
- `CMakeLists.txt` links statically (`-static`); remove that flag if you need dynamic linking.

## Useful commands

```bash
docker compose ps
docker compose logs
docker compose down --remove-orphans
```

## Troubleshooting

**VS Code fails to connect with `TypeError: Cannot read properties of undefined (reading 'parentAuthority')`**

```
[72 ms] Start: Resolving Remote
[83 ms] TypeError: Cannot read properties of undefined (reading 'parentAuthority')
```

This appears with the snap build of VS Code. Replace it with the package from Microsoft's apt repository:

```bash
sudo snap remove code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
```

## Roadmap

- **Production image:** `docker compose --profile prod up --build` (the `prod` profile is not defined yet).
- **Multi-architecture build (x86_64 and ARM64):**
  ```bash
  docker buildx create --use
  docker buildx inspect --bootstrap
  docker buildx build --platform linux/amd64,linux/arm64 -t your-image-name:latest .
  ```
  Add `--push` to publish to a registry.
