conan install . --output-folder=build/dev --build=missing -s build_type=Debug -c tools.cmake.cmaketoolchain:generator=Ninja
cmake --preset=dev
cmake --build --preset=build-dev
# ./build/dev/bin/hello_cpp
