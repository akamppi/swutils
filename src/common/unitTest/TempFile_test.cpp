// Copyright 2022 Antti Kamppi

#include <TempFile.hpp>

#include <gtest/gtest.h>

namespace swutils
{
namespace common
{

TEST(initialTest, constructor)
{
    TempFile file("foo");
}

} // namespace common
} // namespace swutils
