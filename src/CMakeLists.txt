# Copyright: 2018 Antti Kamppi

cmake_minimum_required (VERSION 3.24.3)
project(swutils
    VERSION 0.1.0
    DESCRIPTION "Various reusable and generic software utilities mainly in C++ code"
    HOMEPAGE_URL "https://github.com/akamppi/swutils"
)

# Configure the URL where googletest library can be downloaded from
set(GOOGLETEST_URL "https://github.com/google/googletest/archive/refs/heads/main.zip" CACHE STRING "URL of Googletest library")

# *************************************************************************************************
# Load pkg-config support

find_package(PkgConfig)

# *************************************************************************************************
# Include cmake modules 

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../CMakeModules)
include(googletest_build)
include(print_properties)
include(create_targets)

# *************************************************************************************************
# Compilation options

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

string(CONCAT UT_COMPILER_OPTIONS
   "-g "
)

string(CONCAT COMMON_COMPILER_WARNINGS
    "-Wall "
    "-Wextra "
    "-Werror "
    "-Wshadow "
    "-W "
    "-Wpedantic "
    "-Wmissing-declarations "
    "-Wuninitialized "
    "-Woverloaded-virtual "
    "-Werror-implicit-function-declaration "
    "-Wformat "
    "-Wunknown-pragmas "
    "-Wstrict-aliasing "
    "-Wcast-qual "
    "-Wcast-align "
    "-Wlogical-op "
    "-Wredundant-decls "
    "-Wdisabled-optimization "
)

string(CONCAT STRICT_COMPILER_WARNINGS
    "${COMMON_COMPILER_WARNINGS}"
    "-Weffc++ "
    "-Wundef "
    "-Wsuggest-attribute=const "
    "-Wsuggest-override "
    "-Wfloat-equal "
    "-Wuseless-cast "
    "-Wconversion "
)

set(UNITTEST_OPTIMIZATION
    " -Og "
)

# *************************************************************************************************
# Include other makefiles and their contents (targets and sources etc.)

add_subdirectory(common)
#include(common/Logger/CMakeLists.txt)
#include(common/Logger/unitTests/CMakeLists.txt)
#include(common/SimpleZmq/CMakeLists.txt)
#include(common/SimpleZmq/unitTests/CMakeLists.txt)
#include(common/ThreadPool/CMakeLists.txt)
#include(common/ThreadPool/internal/CMakeLists.txt)
#include(common/ThreadPool/internal/unitTests/CMakeLists.txt)
#include(common/ThreadPool/test_programs/CMakeLists.txt)
#include(common/ThreadPool/unitTests/CMakeLists.txt)
#include(common/utils/CMakeLists.txt)

# *************************************************************************************************
# Custom command to run all unit tests

get_property(_UNITTEST_EXECUTABLES GLOBAL
    PROPERTY UNITTEST_EXECUTABLES
)

add_custom_target(run-unittest-all
    COMMAND $<TARGET_FILE:unittest-common>
    #COMMAND $<TARGET_FILE:unittest-logger>
    #COMMAND $<TARGET_FILE:unittest-utils>
    #COMMAND $<TARGET_FILE:unittest-simplezmq>
    DEPENDS ${_UNITTEST_EXECUTABLES}
    COMMENT "Running all unit tests" VERBATIM
)

# *************************************************************************************************
# Generate report of all targets and their properties

# Property is populated through target create functions
get_property(_ALL_TARGET_NAMES GLOBAL
    PROPERTY ALL_TARGET_NAMES   
)
print_all_target_properties("${_ALL_TARGET_NAMES}")
