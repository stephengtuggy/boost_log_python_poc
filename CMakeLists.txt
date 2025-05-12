# The MIT License (MIT)
#
# Copyright © 2023-2025 Stephen G. Tuggy
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

cmake_minimum_required(VERSION 3.21 FATAL_ERROR)

IF (POLICY CMP0087)
    cmake_policy(SET CMP0087 NEW)
ENDIF ()

IF (POLICY CMP0167)
    CMAKE_POLICY (SET CMP0167 NEW)
ENDIF (POLICY CMP0167)

SET(CPACK_BUILD_CONFIG ${CMAKE_BUILD_TYPE})

project(boost_log_python_poc
        LANGUAGES CXX
        VERSION 0.1.4)

set(CMAKE_CXX_STANDARD 14)
SET(CMAKE_CXX_STANDARD_REQUIRED TRUE)
SET(CMAKE_CXX_EXTENSIONS ON)

SET(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
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

MESSAGE(STATUS "Python library : ${Python3_LIBRARIES} (${Python3_VERSION})")
MESSAGE(STATUS "Python include dir : ${Python3_INCLUDE_DIRS}")

FIND_PACKAGE(Boost REQUIRED COMPONENTS ${BOOST_PYTHON_COMPONENT} log log_setup)
include_directories(${Python3_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

add_executable(boost_log_python_poc main.cpp)
target_compile_definitions(boost_log_python_poc PUBLIC "BOOST_PYTHON_NO_PY_SIGNATURES" "BOOST_ALL_DYN_LINK" "$<$<CONFIG:Debug>:BOOST_DEBUG_PYTHON>")
if (WIN32)
    target_compile_definitions(boost_log_python_poc PUBLIC BOOST_USE_WINAPI_VERSION=0x0A00)
    target_compile_definitions(boost_log_python_poc PUBLIC _WIN32_WINNT=0x0A00)
    target_compile_definitions(boost_log_python_poc PUBLIC WINVER=0x0A00)
    target_compile_definitions(boost_log_python_poc PUBLIC "$<$<CONFIG:Debug>:Py_DEBUG>")
endif ()

target_link_libraries(boost_log_python_poc PRIVATE ${Python3_LIBRARIES} ${Boost_LIBRARIES})

# Should we install gtest?
OPTION(INSTALL_GTEST "Should we download and install GTest?" ON)

# Should we run gtest?
OPTION(USE_GTEST "Should we build and run the unit tests using GTest?" ON)

INCLUDE(GNUInstallDirs)

SET(CPACK_PACKAGE_NAME "Boost_Log_Python_POC")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Proof of Concept for Boost Log, Python, and Boost Python all working together")
SET(CPACK_PACKAGE_VENDOR "Stephen G. Tuggy")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")
SET(CPACK_PACKAGE_VERSION_MAJOR 0)
SET(CPACK_PACKAGE_VERSION_MINOR 1)
SET(CPACK_PACKAGE_VERSION_PATCH 4)
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "Boost_Log_Python_POC")
SET(CPACK_PACKAGE_EXECUTABLES "boost_log_python_poc")
SET(CPACK_CONTACT "sgt@stephengtuggy.com")

SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-Source")
SET(CPACK_SOURCE_GENERATOR "TBZ2" "TXZ")

# See https://gitlab.kitware.com/cmake/community/-/wikis/doc/cpack/PackageGenerators for generator lists
IF (CMAKE_SYSTEM_NAME STREQUAL Windows)
    MESSAGE(STATUS "Configuring Packaging for Windows")
    # NSIS - See https://cmake.org/cmake/help/v3.3/module/CPackNSIS.html
    # NSI bug requires at least 1 set of 4 forwards slashes??
    SET(CPACK_NSIS_DISPLAY_NAME "Boost_Log_Python_POC")
    SET(CPACK_NSIS_HELP_LINK "https:\\\\stephengtuggy.com")
    SET(CPACK_NSIS_URL_INFO_ABOUT "https:\\\\stephengtuggy.com")
    SET(CPACK_NSIS_CONTACT "sgt@stephengtuggy.com")
    SET(CPACK_NSIS_MODIFY_PATH ON)

    # Windows installer format(s) to output to
    SET(CPACK_GENERATOR "NSIS64")
    SET(CPACK_PACKAGE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/packages")
    SET(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_Windows_${CMAKE_SYSTEM_VERSION}_${CMAKE_SYSTEM_PROCESSOR}")
    SET(CPACK_PACKAGE_EXECUTABLES "${CMAKE_CURRENT_BINARY_DIR}/${CPACK_BUILD_CONFIG}/boost_log_python_poc.exe" "${CMAKE_CURRENT_BINARY_DIR}/${CPACK_BUILD_CONFIG}/boost_log_python_poc.exe")
ELSE ()
    MESSAGE(WARNING "Packaging boost_log_python_poc is not supported on this platform at this time")
ENDIF ()

INCLUDE(CPack)

IF (INSTALL_GTEST OR USE_GTEST)
    MESSAGE(STATUS "Configuring Unit Tests")
    ENABLE_TESTING()

    IF (INSTALL_GTEST)
        INCLUDE(FetchContent)
        FetchContent_Declare(
                googletest
                GIT_REPOSITORY https://github.com/google/googletest.git
                GIT_TAG        v1.15.2
        )

        # Set custom variables, policies, etc.

        # For Windows: Prevent overriding the parent project's compiler/linker settings
        SET(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

        FetchContent_MakeAvailable(googletest)
    ENDIF (INSTALL_GTEST)
ENDIF (INSTALL_GTEST OR USE_GTEST)
