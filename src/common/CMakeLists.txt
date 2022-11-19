# Copyright 2022 Antti Kamppi

enable_testing()

setup_unittest_executable(unittest-common
    SOURCES
        TempFile.cpp
        unitTest/TempFile_test.cpp
)
