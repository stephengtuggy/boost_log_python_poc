# The MIT License (MIT)
#
# Copyright © 2023-2024 Stephen G. Tuggy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(boost_log_python_poc
        LANGUAGES CXX
        VERSION 0.1.1)

set(CMAKE_CXX_STANDARD 11)
SET(CMAKE_CXX_STANDARD_REQUIRED TRUE)
SET(CMAKE_CXX_EXTENSIONS ON)

SET(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
SET(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
INCLUDE(InstallRequiredSystemLibraries)

OPTION(ENABLE_PIE "Enable Position Independent Executables" ON)

include(CheckPIESupported)
check_pie_supported()
UNSET(CMAKE_POSITION_INDEPENDENT_CODE)
IF (ENABLE_PIE)
    SET(CMAKE_POSITION_INDEPENDENT_CODE ON)
ELSE (ENABLE_PIE)
    SET(CMAKE_POSITION_INDEPENDENT_CODE OFF)
ENDIF (ENABLE_PIE)

FIND_PACKAGE(Python3 REQUIRED COMPONENTS Development Interpreter)
SET(BOOST_PYTHON_COMPONENT "python${Python3_VERSION_MAJOR}${Python3_VERSION_MINOR}")
FIND_PACKAGE(Boost REQUIRED COMPONENTS ${BOOST_PYTHON_COMPONENT} log log_setup)
include_directories(${Python3_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

add_executable(boost_log_python_poc main.cpp)
if (WIN32)
    target_compile_definitions(boost_log_python_poc PUBLIC "BOOST_ALL_DYN_LINK" "$<$<CONFIG:Debug>:BOOST_DEBUG_PYTHON>" "$<$<CONFIG:Debug>:Py_DEBUG>")
    target_compile_definitions(boost_log_python_poc PUBLIC BOOST_USE_WINAPI_VERSION=0x0A00)
    target_compile_definitions(boost_log_python_poc PUBLIC _WIN32_WINNT=0x0A00)
    target_compile_definitions(boost_log_python_poc PUBLIC WINVER=0x0A00)
endif ()

target_link_libraries(boost_log_python_poc PRIVATE ${Python3_LIBRARIES} ${Boost_LIBRARIES})
