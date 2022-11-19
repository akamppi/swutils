# Copyright 2022 Antti Kamppi

enable_testing()

setup_unittest_executable(unittest-common
    SOURCES
        TempFile.cpp
    TEST_SOURCES
        unitTest/TempFile_test.cpp
    INCLUDE_DIRS
        ${CMAKE_CURRENT_SOURCE_DIR}
)
