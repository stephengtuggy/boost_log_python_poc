# The MIT License (MIT)
#
# Copyright © 2023-2026 Stephen G. Tuggy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

param(
    [String]$PresetName = "VS2022Win64-pie-enabled-RelWithDebInfo",
    [String]$BuildType = "RelWithDebInfo" # You can also specify "Debug" or "Release"
)

[Int32]$MAX_THREADS_TO_BUILD_WITH=6
[Int32]$num_threads_to_build_with=[Int32]::Parse($env:NUMBER_OF_PROCESSORS)
echo "Number of threads to build with before capping: $num_threads_to_build_with"
$num_threads_to_build_with=[Int32]::Min($num_threads_to_build_with, $MAX_THREADS_TO_BUILD_WITH)
echo "Number of threads to build with after capping: $num_threads_to_build_with"

[String]$baseDir = (Get-Location -PSProvider "FileSystem").Path
[String]$binaryDir = "$baseDir\build\$PresetName"

cmake --preset $PresetName "-DNUM_THREADS_TO_BUILD_WITH=$num_threads_to_build_with"
cmake --build --preset "build-$PresetName" -v
