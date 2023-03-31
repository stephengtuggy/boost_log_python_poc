cmake_minimum_required(VERSION 3.16 FATAL_ERROR)
project(boost_log_python_poc)

set(CMAKE_CXX_STANDARD 11)

FIND_PACKAGE(Python3 REQUIRED COMPONENTS Development Interpreter)
SET(BOOST_PYTHON_COMPONENT "python${Python3_VERSION_MAJOR}${Python3_VERSION_MINOR}")
FIND_PACKAGE(Boost REQUIRED COMPONENTS ${BOOST_PYTHON_COMPONENT} )
include_directories(${Python3_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS})

add_executable(boost_log_python_poc main.cpp)
target_compile_definitions(boost_log_python_poc PUBLIC "BOOST_ALL_DYN_LINK" "$<$<CONFIG:Debug>:BOOST_DEBUG_PYTHON>" "$<$<CONFIG:Debug>:Py_DEBUG>")
target_compile_definitions(boost_log_python_poc PUBLIC BOOST_USE_WINAPI_VERSION=0x0A00)
target_compile_definitions(boost_log_python_poc PUBLIC _WIN32_WINNT=0x0A00)
target_compile_definitions(boost_log_python_poc PUBLIC WINVER=0x0A00)

target_link_libraries(boost_log_python_poc PRIVATE ${Python3_LIBRARIES} ${Boost_LIBRARIES})
