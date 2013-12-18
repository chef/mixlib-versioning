#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
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

require 'mixlib/versioning'

shared_examples Mixlib::Versioning::Format::SemVer do

  it_should_behave_like "Basic SemVer"

  it_has_behavior "parses valid version strings", {
    "1.0.0-alpha.1" => {
      :major => 1,
      :minor => 0,
      :patch => 0,
      :prerelease => "alpha.1",
      :build => nil,
      :release? => false,
      :prerelease? => true,
      :build? => false,
      :release_build? => false,
      :prerelease_build? => false
    },
    "1.0.0+20130308110833" => {
      :major => 1,
      :minor => 0,
      :patch => 0,
      :prerelease => nil,
      :build => "20130308110833",
      :release? => false,
      :prerelease? => false,
      :build? => true,
      :release_build? => true,
      :prerelease_build? => false
    },
    "1.0.0-beta.3+20130308110833" => {
      :major => 1,
      :minor => 0,
      :patch => 0,
      :prerelease => "beta.3",
      :build => "20130308110833",
      :release? => false,
      :prerelease? => false,
      :build? => true,
      :release_build? => false,
      :prerelease_build? => true
    }
  }

  it_has_behavior "rejects invalid version strings", {
    "8.8.8.8" => "too many segments: MAJOR.MINOR.PATCH.EXTRA",
    "01.1.1" => "leading zero invalid",
    "1.01.1" => "leading zero invalid",
    "1.1.01" => "leading zero invalid",
    "1.0.0-" => "empty prerelease identifier",
    "1.0.0-alpha.." => "empty prerelease identifier",
    "1.0.0-01.02.03" => "leading zero invalid",
    "1.0.0-alpha.01" => "leading zero invalid",
    "6.3.1+" => "empty build identifier",
    "6.4.8-alpha.1.2.3+build." => "empty build identifier"
  }

  describe "build qualification" do
    context "release version" do
      let(:version_string){"1.0.0"}
      its(:release?){ should be_true }
      its(:prerelease?){ should be_false }
      its(:build?){ should be_false }
      its(:release_build?){ should be_false }
      its(:prerelease_build?){ should be_false }
    end

    context "pre-release version" do
      let(:version_string){"1.0.0-alpha.1"}
      its(:release?){ should be_false }
      its(:prerelease?){ should be_true }
      its(:build?){ should be_false }
      its(:release_build?){ should be_false }
      its(:prerelease_build?){ should be_false }
    end

    context "pre-release build version" do
      let(:version_string){"1.0.0-alpha.1+20130308110833"}
      its(:release?){ should be_false }
      its(:prerelease?){ should be_false }
      its(:build?){ should be_true }
      its(:release_build?){ should be_false }
      its(:prerelease_build?){ should be_true }
    end

    context "release build version" do
      let(:version_string){"1.0.0+20130308110833"}
      its(:release?){ should be_false }
      its(:prerelease?){ should be_false }
      its(:build?){ should be_true }
      its(:release_build?){ should be_true }
      its(:prerelease_build?){ should be_false }
    end
  end
end
