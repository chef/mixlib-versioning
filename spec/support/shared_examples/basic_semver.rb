#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Copyright:: Copyright (c) 2013 Opscode, Inc.
# License:: Apache License, Version 2.0
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
#

shared_examples 'Basic SemVer' do
  it_has_behavior 'parses valid version strings', {
    '1.2.3' => {
      major: 1,
      minor: 2,
      patch: 3,
      prerelease: nil,
      build: nil,
      release?: true,
      prerelease?: false,
      build?: false,
      release_build?: false,
      prerelease_build?: false,
    },
  }

  it_has_behavior 'rejects invalid version strings', {
    'a.1.1' => 'non-numeric MAJOR',
    '1.a.1' => 'non-numeric MINOR',
    '1.1.a' => 'non-numeric PATCH',
  }
end
