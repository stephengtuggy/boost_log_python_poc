#!/usr/bin/env bash
# The MIT License (MIT)
#
# Copyright © 2026 Stephen G. Tuggy
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
# ====================================
# @file   : bootstrap-on-mac.sh
# @brief  : installs dependencies for building boost_log_python_poc on macOS
# @usage  : sudo script/bootstrap-on-mac.sh 1 (to run brew update in the process)
#     or  : sudo script/bootstrap-on-mac.sh 0 (to skip running brew update)
# @param  : just one parameter, either a 1 or a 0, to indicate whether or not to
#           run brew update
# ====================================

set -e

UPDATE_ALL_SYSTEM_PACKAGES="$1"

DETECT_MAC_OS_VERSION=$(sw_vers -productVersion | cut -f 1,2 -d '.')
echo "Detected macOS Version: ${DETECT_MAC_OS_VERSION}"

if [ "${UPDATE_ALL_SYSTEM_PACKAGES}" -eq 1 ]
then
  # Ensure we're using the latest formulae
  brew update
fi

brew install \
    gcc \
    python3 \
    boost-python3 \
    ninja

# Only install cmake if it isn't installed yet
brew ls --versions cmake || brew install cmake
