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

describe Mixlib::Versioning::Format::SemVer do
  subject { described_class.new(version_string) }

  it_should_behave_like Mixlib::Versioning::Format::SemVer

  it_has_behavior 'serializable', [
    '1.0.0',
    '1.0.0-alpha.1',
    '1.0.0-alpha.1+some.build.version',
    '1.0.0+build.build.build',
  ]

  it_has_behavior 'sortable' do
    let(:unsorted_version_strings) do
      %w(
        1.0.0-beta.2
        1.0.0-alpha
        1.0.0-alpha.july
        1.0.0-rc.1+build.1
        1.0.0
        1.0.0-beta.11
        1.0.0+0.3.7
        1.0.0-rc.1
        1.0.0-alpha.1
        1.3.7+build.2.b8f12d7
        1.3.7+build.11.e0f985a
        1.3.7+build
      )
    end
    let(:sorted_version_strings) do
      %w(
        1.0.0-alpha
        1.0.0-alpha.1
        1.0.0-alpha.july
        1.0.0-beta.2
        1.0.0-beta.11
        1.0.0-rc.1
        1.0.0-rc.1+build.1
        1.0.0
        1.0.0+0.3.7
        1.3.7+build
        1.3.7+build.2.b8f12d7
        1.3.7+build.11.e0f985a
      )
    end
    let(:min) { '1.0.0-alpha' }
    let(:max) { '1.3.7+build.11.e0f985a' }
  end # it_has_behavior

  it_has_behavior 'filterable' do
    let(:unsorted_version_strings) do
      %w(
        1.0.0-beta.2
        1.0.0-alpha
        1.0.0-rc.1+build.1
        1.0.0
        1.0.0-beta.11
        1.0.0+0.3.7
        1.0.0-rc.1
        1.0.0-alpha.1
        1.3.7+build.2.b8f12d7
        1.3.7+build.11.e0f985a
        1.3.7+build
      )
    end
    let(:release_versions) do
      %w(
        1.0.0      )
    end
    let(:prerelease_versions) do
      %w(
        1.0.0-beta.2
        1.0.0-alpha
        1.0.0-beta.11
        1.0.0-rc.1
        1.0.0-alpha.1
      )
    end
    let(:build_versions) do
      %w(
        1.0.0-rc.1+build.1
        1.0.0+0.3.7
        1.3.7+build.2.b8f12d7
        1.3.7+build.11.e0f985a
        1.3.7+build
      )
    end
    let(:release_build_versions) do
      %w(
        1.0.0+0.3.7
        1.3.7+build.2.b8f12d7
        1.3.7+build.11.e0f985a
        1.3.7+build
      )
    end
    let(:prerelease_build_versions) do
      %w(
        1.0.0-rc.1+build.1      )
    end
  end # it_has_behavior

  it_has_behavior 'comparable', [
    '0.1.0', '0.2.0',
    '1.0.0-alpha.1', '1.0.0',
    '1.2.3', '1.2.3+build.123',
    '2.0.0-beta.1', '2.0.0-beta.1+build.123'
  ]
end # describe
