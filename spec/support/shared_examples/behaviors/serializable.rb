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

shared_examples 'serializable' do |version_strings|
  describe '#to_s' do
    version_strings.each do |v|
      it "reconstructs the initial input for #{v}" do
        described_class.new(v).to_s.should == v
      end # it
    end # version_strings
  end # describe

  describe '#to_semver_string' do
    version_strings.each do |v|
      it "generates a semver version string for #{v}" do
        subject = described_class.new(v)
        string = subject.to_semver_string
        semver = Mixlib::Versioning::Format::SemVer.new(string)
        string.should eq semver.to_s
      end # it
    end # version_strings
  end # describe

  describe '#to_rubygems_string' do
    version_strings.each do |v|
      it "generates a rubygems version string for #{v}" do
        subject = described_class.new(v)
        string = subject.to_rubygems_string
        rubygems = Mixlib::Versioning::Format::Rubygems.new(string)
        string.should eq rubygems.to_s
      end # it
    end # version_strings
  end # describe
end # shared_examples
