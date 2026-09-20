cmake_minimum_required(VERSION 3.22)
project(hello_cpp)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_EXE_LINKER_FLAGS "-static")  # <<< 🔥 static build

find_package(fmt REQUIRED)

add_executable(hello_cpp src/main.cpp)
target_link_libraries(hello_cpp PRIVATE fmt::fmt)
