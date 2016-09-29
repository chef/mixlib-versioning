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

require "spec_helper"

describe Mixlib::Versioning::Format::OpscodeSemVer do
  subject { described_class.new(version_string) }

  it_should_behave_like Mixlib::Versioning::Format::SemVer

  it_has_behavior "rejects invalid version strings", {
    "1.0.0-poop.0" => "non-valid pre-release type",
    "1.0.0+2010AA08010101" => "a malformed timestamp",
    "1.0.0+cvs.33.e0f985a" => "a malformed git describe: no git string",
    "1.0.0+git.AA.e0f985a" => "a malformed git describe: non-numeric COMMITS_SINCE",
    "1.0.0+git.33.z0f985a" => "a malformed git describe: invalid SHA1",
    "11.0.08-rc.1+20130308110833" => "leading zero invalid",
    "01.0.8-alpha.2+20130308110833.git.2.94a1dde" => "leading zero invalid",
    "11.02.8-rc.1+20130308110833" => "leading zero invalid",
    "0008.1.4" => "leading zero invalid",
    "11.00000000002.8-rc.1+20130308110833" => "leading zero invalid",
    "4.67.00012+build.20131219" => "leading zero invalid",
    "3.6.7-rc.007" => "leading zero invalid",
  }

  it_has_behavior "serializable", [
    "1.0.0",
    "1.0.0-alpha.1",
    "1.0.0-alpha.1+20130308110833",
    "1.0.0+20130308110833.git.2.94a1dde",
  ]

  it_has_behavior "sortable" do
    let(:unsorted_version_strings) do
      %w{
        1.0.0-beta.2
        1.0.0-alpha
        1.0.0-rc.1+20130309074433
        1.0.0
        1.0.0-beta.11
        1.0.0+20121009074433
        1.0.0-rc.1
        1.0.0-alpha.1
        1.3.7+20131009104433.git.2.94a1dde
        1.3.7+20131009104433
        1.3.7+20131009074433
      }
    end
    let(:sorted_version_strings) do
      %w{
        1.0.0-alpha
        1.0.0-alpha.1
        1.0.0-beta.2
        1.0.0-beta.11
        1.0.0-rc.1
        1.0.0-rc.1+20130309074433
        1.0.0
        1.0.0+20121009074433
        1.3.7+20131009074433
        1.3.7+20131009104433
        1.3.7+20131009104433.git.2.94a1dde
      }
    end
    let(:min) { "1.0.0-alpha" }
    let(:max) { "1.3.7+20131009104433.git.2.94a1dde" }
  end # it_has_behavior

  it_has_behavior "filterable" do
    let(:unsorted_version_strings) do
      %w{
        1.0.0-beta.2
        1.0.0-alpha
        1.0.0-rc.1+20130309074433
        1.0.0
        1.0.0-beta.11
        1.0.0+20121009074433
        1.0.0-rc.1
        1.0.0-alpha.1
        1.3.7+20131009104433.git.2.94a1dde
        1.3.7+20131009104433
        1.3.7+20131009074433
      }
    end
    let(:release_versions) { %w{1.0.0} }
    let(:prerelease_versions) do
      %w{
        1.0.0-beta.2
        1.0.0-alpha
        1.0.0-beta.11
        1.0.0-rc.1
        1.0.0-alpha.1
      }
    end
    let(:build_versions) do
      %w{
        1.0.0-rc.1+20130309074433
        1.0.0+20121009074433
        1.3.7+20131009104433.git.2.94a1dde
        1.3.7+20131009104433
        1.3.7+20131009074433
      }
    end
    let(:release_build_versions) do
      %w{
        1.0.0+20121009074433
        1.3.7+20131009104433.git.2.94a1dde
        1.3.7+20131009104433
        1.3.7+20131009074433
      }
    end
    let(:prerelease_build_versions) do
      %w{
        1.0.0-rc.1+20130309074433      }
    end
  end # it_has_behavior

  it_has_behavior "comparable", [
    "0.1.0", "0.2.0",
    "1.0.0-alpha.1", "1.0.0",
    "1.2.3", "1.2.3+20121009074433",
    "2.0.0-beta.1", "2.0.0+20131009104433.git.2.94a1dde"
  ]
end # describe
