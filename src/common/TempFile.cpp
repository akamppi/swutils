// Copyright 2022 Antti Kamppi

#include "TempFile.hpp"

#include <iostream>
#include <string>

namespace swutils
{
namespace common
{

TempFile::TempFile(const std::string& filePath)
{
    std::cout << "TempFile(" << filePath << ")" << std::endl;
}

TempFile::~TempFile()
{
    std::cout << "~TempFile()" << std::endl;
}

} // namespace common
} // namespace swutils
