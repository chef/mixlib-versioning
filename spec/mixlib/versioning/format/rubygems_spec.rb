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

require 'spec_helper'

describe Mixlib::Versioning::Format::Rubygems do
  subject { described_class.new(version_string) }

  it_should_behave_like 'Basic SemVer'

  it_has_behavior 'parses valid version strings', {
    '10.1.1' => {
      major: 10,
      minor: 1,
      patch: 1,
      prerelease: nil,
      build: nil,
      release?: true,
      prerelease?: false,
      build?: false,
      release_build?: false,
      prerelease_build?: false,
      iteration: 0,
    },
    '10.1.1.alpha.1' => {
      major: 10,
      minor: 1,
      patch: 1,
      prerelease: 'alpha.1',
      build: nil,
      release?: false,
      prerelease?: true,
      build?: false,
      release_build?: false,
      prerelease_build?: false,
      iteration: 0,
    },
    '11.0.8.rc.3' => {
      major: 11,
      minor: 0,
      patch: 8,
      prerelease: 'rc.3',
      build: nil,
      release?: false,
      prerelease?: true,
      build?: false,
      release_build?: false,
      prerelease_build?: false,
      iteration: 0,
    },
    '11.0.8-33' => {
      major: 11,
      minor: 0,
      patch: 8,
      prerelease: nil,
      build: nil,
      release?: true,
      prerelease?: false,
      build?: false,
      release_build?: false,
      prerelease_build?: false,
      iteration: 33,
    },
    '11.0.8.rc.3-1' => {
      major: 11,
      minor: 0,
      patch: 8,
      prerelease: 'rc.3',
      build: nil,
      release?: false,
      prerelease?: true,
      build?: false,
      release_build?: false,
      prerelease_build?: false,
      iteration: 1,
    },
  }

  it_has_behavior 'rejects invalid version strings', {
    '1.1.1-rutro' => 'dash for pre-release delimeter',
  }

  it_has_behavior 'serializable', [
    '1.0.0',
    '1.0.0.alpha.1',
    '1.0.0.beta',
  ]

  it_has_behavior 'sortable' do
    let(:unsorted_version_strings) do
      %w(
        1.0.0.beta.2
        1.3.7.alpha.0
        1.0.0.alpha
        1.0.0.rc.1
        1.0.0
      )
    end
    let(:sorted_version_strings) do
      %w(
        1.0.0.alpha
        1.0.0.beta.2
        1.0.0.rc.1
        1.0.0
        1.3.7.alpha.0
      )
    end
    let(:min) { '1.0.0.alpha' }
    let(:max) { '1.3.7.alpha.0' }
  end

  # The +Rubygems+ format only produces release and prerelease versions.
  it_has_behavior 'filterable' do
    let(:unsorted_version_strings) do
      %w(
        1.0.0.beta.2
        1.3.7.alpha.0
        1.0.0.alpha
        1.0.0.rc.1
        1.0.0
      )
    end
    let(:release_versions) { %w(1.0.0) }
    let(:prerelease_versions) do
      %w(
        1.0.0.beta.2
        1.3.7.alpha.0
        1.0.0.alpha
        1.0.0.rc.1
      )
    end
  end

  it_has_behavior 'comparable', [
    '0.1.0', '0.2.0',
    '1.0.0.alpha.1', '1.0.0',
    '1.2.3.alpha', '1.2.3.alpha.1',
    '2.4.5.alpha', '2.4.5.beta',
    '3.0.0.beta.1', '3.0.0.rc.1',
    '3.1.2.rc.42', '3.1.2'
  ]
end
