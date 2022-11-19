// Copyright 2022 Antti Kamppi

#pragma once

#include <string>

namespace swutils
{
namespace common
{

/** @brief Create scoped temporary file to read/write
 *
 * Initializing TempFile will create the file and destructor will remove it.
 */
class TempFile
{
public:
    /// @brief ctor
    /// @param filePath 
    explicit TempFile(const std::string& filePath);

    /// dtor
    ~TempFile();
};

} // namespace common
} // namespace swutils
