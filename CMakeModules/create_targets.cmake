# Copyright: 2018 Antti Kamppi

# Global property to put all target names into
set_property(GLOBAL APPEND
    PROPERTY ALL_TARGET_NAMES
)

set_property(GLOBAL APPEND
    PROPERTY UNITTEST_EXECUTABLES
)

# Setup target properties which are common for executables and unit tests
# 
# Also creates a custom target to run the created target
# Usage: setup_common_target_properties(<target name> <comment for runner> 
# LIBS - List of libraries to link against
# )
function(setup_common_target_properties TARGET_NAME RUNNER_COMMENT)
    set(_multiValArgs LIBS)
    cmake_parse_arguments("arg" "" "" "${_multiValArgs}" ${ARGN})

    # sanitize input arguments
    if (NOT arg_LIBS)
        unset(arg_LIBS)
    endif()

    target_link_libraries(${TARGET_NAME}
        ${arg_LIBS}
    )

    # Create a custom target to run the given executable
    set(_target_runner run-${TARGET_NAME})
    add_custom_target(${_target_runner}
        COMMAND $<TARGET_FILE:${TARGET_NAME}>
        DEPENDS ${TARGET_NAME}
        COMMENT "${RUNNER_COMMENT}" VERBATIM
    )

    # Document the target and its libraries so it can be printed as part of cmake configuration task
    set_property(GLOBAL APPEND 
        PROPERTY ALL_TARGET_NAMES
        ${TARGET_NAME}
    )
    set_property(GLOBAL APPEND
        PROPERTY ${TARGET_NAME}_LINK_LIBRARIES
        ${ARGN}
    )
endfunction(setup_common_target_properties)

# Create a static library with given name
#
# Usage: setup_library(<library name>)
function(setup_library LIBRARY_NAME)
    add_library(${LIBRARY_NAME} 
        STATIC
        ""
    )
    set_target_properties(${LIBRARY_NAME}
        PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib/
        COMPILE_FLAGS "${STRICT_COMPILER_WARNINGS}"
    )
    
    target_include_directories(${LIBRARY_NAME}
        PUBLIC ${PROJECT_SOURCE_DIR}
    )
    
    set_target_properties(${LIBRARY_NAME} PROPERTIES LINKER_LANGUAGE CXX)
    
    set_property(GLOBAL APPEND 
        PROPERTY ALL_TARGET_NAMES
        ${LIBRARY_NAME}
    )
endfunction(setup_library)

# Create an executable unit test executable which uses googletest
#
# The unit test exectable is created with given arguments
# Note: gtest-related libraries, including gmock, are included implicitly and do not need to be listed
#
# Usage: setup_unittest_executable(<unit test name>
# SOURCES - List source files that are to be tested
# TEST_SOURCES - List source files that contain actual test suites/test cases
# LIBS - Libraries to link against (gtest, gmock, gtest-main not needed)
# INCLUDE_DIRS - List of include directories for the test executable
#)
function(setup_unittest_executable UT_EXEC_NAME)
    # parse function arguments
    set(_multiValArgs SOURCES TEST_SOURCES LIBS INCLUDE_DIRS)
    cmake_parse_arguments("arg" "" "" "${_multiValArgs}" ${ARGN})

    # sanitize input arguments
    if (NOT arg_SOURCES)
        unset(arg_SOURCES)
    endif()
    if (NOT arg_TEST_SOURCES)
        unset(arg_TEST_SOURCES)
    endif()

    add_executable(${UT_EXEC_NAME}
        ${arg_SOURCES}
        ${arg_TEST_SOURCES}
    )

    set_target_properties(${UT_EXEC_NAME}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/unitTests/${UT_EXEC_NAME}
        COMPILE_FLAGS "${UT_COMPILER_OPTIONS} ${COMMON_COMPILER_WARNINGS}"
    )

    target_include_directories(${UT_EXEC_NAME}
        PRIVATE
            ${arg_INCLUDE_DIRS}
    )
       
    setup_common_target_properties(${UT_EXEC_NAME}
        "Run unittests for ${UT_EXEC_NAME}"
        LIBS
            PRIVATE
                gtest
                gmock
                gtest_main
                ${arg_LIBS}
    )

    set_property(GLOBAL APPEND
        PROPERTY UNITTEST_EXECUTABLES
        ${UT_EXEC_NAME}
    )
endfunction(setup_unittest_executable)

# Create a group of unit test executables
#
# Usage: setup_unittest_executables(<list of unit test names>)
function(setup_unittest_executables LIST_OF_EXEC_NAMES)
    foreach (_exec ${LIST_OF_EXEC_NAMES})
        setup_unittest_executable(${_exec})
    endforeach()
endfunction(setup_unittest_executables)

# Create a single executable with name <EXEC_NAME>
# 
# Usage: setup_executable(<exec-name>
# SOURCES - List of sources for the executable
# LIBS - List of libraries to link against
# )
function(setup_executable EXEC_NAME)
    set(_multiValArgs SOURCES LIBS)
    cmake_parse_arguments("arg" "" "" "${_multiValArgs}" ${ARGN})

    # sanitize input arguments
    if (NOT arg_SOURCES)
        unset(arg_SOURCES)
    endif()
    if (NOT arg_LIBS)
        unset(arg_LIBS)
    endif()
    
    add_executable(${EXEC_NAME}
        arg_SOURCES
    )
    set_target_properties(${EXEC_NAME}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/test_programs/
        COMPILE_FLAGS "${STRICT_COMPILER_WARNINGS}"
    )
    
    setup_common_target_properties(${EXEC_NAME} "Run executable for ${EXEC_NAME}" 
        LIBS
            ${arg_LIBS}
    )
endfunction(setup_executable)

# Set up a group of executables with names given in a list as first argument
# 
# The executables are linked against libraries given as extra parameters.
# Usage: setup_executables(<exec-name-list> [lib1] [lib2]...)
function(setup_executables LIST_OF_EXEC_NAMES)
    foreach (_exec ${LIST_OF_EXEC_NAMES})
        setup_executable(${_exec} ${ARGN})
    endforeach()
endfunction(setup_executables)