# This file is used for CLion tracking and building executables STANDALONE.
# This file should only be used if you only want to build the C part of LinuxMiniPrograms.

cmake_minimum_required(VERSION 3.2)
project(LinuxMiniPrograms VERSION 1.0.0.0  LANGUAGES C CXX)

if (WIN32)
    MESSAGE(FATAL_ERROR "Platform Win32 Not Supported!")
endif()

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 11)
add_compile_options(-Wall -Wextra -pedantic -DIS_DEBUG)
include_directories(include)
include_directories(/usr/include)

add_library(yuzjstd SHARED lib/yuzjstd_core.c lib/yuzjstd_str.c lib/yuzjstd_io.c include/yuzjstd.h)

add_executable(pst.co bin/pst.c)
add_executable(enigma.co bin/enigma.c)
add_executable(cmain.co test/cmain.c)

target_link_libraries(yuzjstd pcre2-posix)
target_link_libraries(pst.co pthread yuzjstd)
target_link_libraries(enigma.co yuzjstd)
target_link_libraries(cmain.co yuzjstd)
