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

shared_examples 'filterable' do
  let(:unsorted_versions) do
    unsorted_version_strings.map { |v| described_class.new(v) }
  end

  # this should/will be overriden by calling spec
  let(:release_versions) { [] }
  let(:prerelease_versions) { [] }
  let(:build_versions) { [] }
  let(:release_build_versions) { [] }
  let(:prerelease_build_versions) { [] }

  it 'filters by release versions only' do
    unsorted_versions.select(&:release?).should eq(release_versions.map { |v| described_class.new(v) })
  end # it

  it 'filters by pre-release versions only' do
    filtered = unsorted_versions.select(&:prerelease?)
    filtered.should eq(prerelease_versions.map { |v| described_class.new(v) })
  end # it

  it 'filters by build versions only' do
    filtered = unsorted_versions.select(&:build?)
    filtered.should eq(build_versions.map { |v| described_class.new(v) })
  end # it

  it 'filters by release build versions only' do
    filtered = unsorted_versions.select(&:release_build?)
    filtered.should eq(release_build_versions.map { |v| described_class.new(v) })
  end # it

  it 'filters by pre-release build versions only' do
    filtered = unsorted_versions.select(&:prerelease_build?)
    filtered.should eq(prerelease_build_versions.map { |v| described_class.new(v) })
  end # it
end # shared_examples
