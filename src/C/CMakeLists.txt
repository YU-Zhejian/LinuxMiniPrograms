# This file is used for CLion tracking ONLY.
# DO NOT USE THIS FILE TO BUILD EXECUTABLES.

cmake_minimum_required(VERSION 3.2)
project(LinuxMiniPrograms VERSION 1.0.0.0  LANGUAGES C CXX)

if (WIN32)
    MESSAGE(FATAL_ERROR "Platform Win32 Not Supported!")
endif()

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)
include_directories(include)

add_library(yuzjstd SHARED lib/yuzjstd.c include/yuzjstd.h)

add_executable(pst.co bin/pst.c)

target_link_libraries(pst.co pthread yuzjstd)
