cmake_minimum_required(VERSION 3.10)
project(interp LANGUAGES CXX ASM)
set(CMAKE_CXX_STANDARD 17)

add_executable(asmfuck src/main.cpp src/asmfuck.S)

set(ASM_OPTIONS "-x assembler-with-cpp")
set(CMAKE_ASM_FLAGS "${CFLAGS} ${ASM_OPTIONS}" )