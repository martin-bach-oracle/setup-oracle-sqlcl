#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
#
# Copyright 2026 Gerald Venzl, Andres Almiray, Martin Bach
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

echo "::group::⬇️ Download SQLcl"

if [[ ${VERSION} == "latest" ]]; then

  # Download well-known latest version of SQLcl (default)
  curl --fail --location --show-error --silent --retry 3 \
    -o "sqlcl.zip" \
    "https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip"

elif [[ "${VERSION}" =~ ^[0-9]{2}\.[0-9]+\.[0-9]+\.[0-9]{3}\.[0-9]{4}$ ]]; then

  # Download a specific version, use the fully qualified release name like
  # in homebrew
  download_link="https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-${VERSION}.zip"
  curl --fail --location --show-error --silent --retry 3 \
    -o "sqlcl.zip" \
    "${download_link}"
else
  # incorrect version specified
  echo "❌ SQLcl version '${VERSION}' is not valid."
  echo "Make sure that the version exists!"
  exit 1;
fi;

echo "::endgroup::"

echo "::group::📦 Extract SQLcl"

# Extract sqlcl
unzip -qo "sqlcl.zip"

echo "SQLCL_HOME=${PWD}/sqlcl" >> "$GITHUB_ENV"

# State version
"${PWD}/sqlcl/bin/sql" -version

echo "${PWD}/sqlcl/bin" >> "$GITHUB_PATH"

echo "::endgroup::"
