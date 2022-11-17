// Copyright 2022 Antti Kamppi

#pragma once

namespace swutils
{
namespace common
{

#include <string_view>

/** @brief Create scoped temporary file to read/write
 *
 * Initializing TempFile will create the file and destructor will remove it.
 */
class TempFile
{
public:
    /// @brief ctor
    /// @param filePath 
    explicit TempFile(std::string_view filePath);

    /// dtor
    ~TempFile();
};

} // namespace common
} // namespace swutils
