// Copyright 2022 Antti Kamppi

#include "TempFile.hpp"

#include <iostream>

namespace swutils
{
namespace common
{

TempFile::TempFile(std::string_view filePath) :
{
    std::cout << "TempFile(" << filePath << ")" << std::endl;
}

TempFile::~TempFile()
{
    std::cout << "~TempFile()" << std::endl;
}

} // namespace common
} // namespace swutils
