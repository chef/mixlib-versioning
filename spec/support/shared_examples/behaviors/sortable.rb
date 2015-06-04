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

shared_examples 'sortable' do
  let(:unsorted_versions) do
    unsorted_version_strings.map { |v| described_class.new(v) }
  end

  let(:sorted_versions) do
    sorted_version_strings.map { |v| described_class.new(v) }
  end

  it 'responds to <=>' do
    described_class.should respond_to(:<=>)
  end

  it 'sorts all properly' do
    unsorted_versions.sort.should eq sorted_versions
  end

  it 'finds the min' do
    unsorted_versions.min.should eq described_class.new(min)
  end

  it 'finds the max' do
    unsorted_versions.max.should eq described_class.new(max)
  end
end # shared_examples
