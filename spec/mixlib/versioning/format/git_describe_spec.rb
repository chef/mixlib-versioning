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

describe Mixlib::Versioning::Format::GitDescribe do
  subject { described_class.new(version_string) }

  it_has_behavior "parses valid version strings", {
    "0.10.8-231-g59d6185" => {
      major: 0,
      minor: 10,
      patch: 8,
      prerelease: nil,
      build: "231.g59d6185.0",
      release?: false,
      prerelease?: false,
      build?: true,
      release_build?: true,
      prerelease_build?: false,
      commits_since: 231,
      commit_sha: "59d6185",
      iteration: 0,
    },
    "10.16.2-49-g21353f0-1" => {
      major: 10,
      minor: 16,
      patch: 2,
      prerelease: nil,
      build: "49.g21353f0.1",
      release?: false,
      prerelease?: false,
      build?: true,
      release_build?: true,
      prerelease_build?: false,
      commits_since: 49,
      commit_sha: "21353f0",
      iteration: 1,
    },
    "10.16.2.rc.1-49-g21353f0-1" => {
      major: 10,
      minor: 16,
      patch: 2,
      prerelease: "rc.1",
      build: "49.g21353f0.1",
      release?: false,
      prerelease?: false,
      build?: true,
      release_build?: false,
      prerelease_build?: true,
      commits_since: 49,
      commit_sha: "21353f0",
      iteration: 1,
    },
    "10.16.2-alpha-49-g21353f0-1" => {
      major: 10,
      minor: 16,
      patch: 2,
      prerelease: "alpha",
      build: "49.g21353f0.1",
      release?: false,
      prerelease?: false,
      build?: true,
      release_build?: false,
      prerelease_build?: true,
      commits_since: 49,
      commit_sha: "21353f0",
      iteration: 1,
    },
    "10.16.2-alpha-49-g21353f0" => {
      major: 10,
      minor: 16,
      patch: 2,
      prerelease: "alpha",
      build: "49.g21353f0.0",
      release?: false,
      prerelease?: false,
      build?: true,
      release_build?: false,
      prerelease_build?: true,
      commits_since: 49,
      commit_sha: "21353f0",
      iteration: 0,
    },
  }

  it_has_behavior "rejects invalid version strings", {
    "1.0.0" => "no git describe data",
    "1.0.0-alpha.1" => "no git describe data",
    "1.0.0-alpha.1+build.deadbeef" => "no git describe data",
    "1.0.0-123-gfd0e3a65282cb5f6df3bab6a53f4fcb722340d499-1" => "too many SHA1 characters",
    "1.0.0-123-gdeadbe-1" => "too few SHA1 characters",
    "1.0.0-123-gNOTHEX1-1" => "illegal SHA1 characters",
    "1.0.0-123-g1234567-alpha" => "non-numeric iteration",
    "1.0.0-alpha-poop-g1234567-1" => "non-numeric 'commits_since'",
    "1.0.0-g1234567-1" => "missing 'commits_since'",
    "1.0.0-123-1" => "missing SHA1",
  }

  version_strings = %w{
    9.0.1-1-gdeadbee-1
    9.1.2-2-g1234567-1
    10.0.0-1-gabcdef3-1
    10.5.7-2-g21353f0-1
    10.20.2-2-gbbbbbbb-1
    10.20.2-3-gaaaaaaa-1
    9.0.1-2-gdeadbe1-1
    9.0.1-2-gdeadbe1-2
    9.0.1-2-gdeadbe2-1
    9.1.1-2-g1234567-1
  }

  it_has_behavior "serializable", version_strings

  it_has_behavior "sortable" do
    let(:unsorted_version_strings) { version_strings }
    let(:sorted_version_strings) do
      %w{
        9.0.1-1-gdeadbee-1
        9.0.1-2-gdeadbe1-1
        9.0.1-2-gdeadbe1-2
        9.0.1-2-gdeadbe2-1
        9.1.1-2-g1234567-1
        9.1.2-2-g1234567-1
        10.0.0-1-gabcdef3-1
        10.5.7-2-g21353f0-1
        10.20.2-2-gbbbbbbb-1
        10.20.2-3-gaaaaaaa-1
      }
    end
    let(:min) { "9.0.1-1-gdeadbee-1" }
    let(:max) { "10.20.2-3-gaaaaaaa-1" }
  end # it_has_behavior

  # The +GitDescribe+ format only produces release build versions.
  it_has_behavior "filterable" do
    let(:unsorted_version_strings) { version_strings }
    let(:build_versions) do
      %w{
        9.0.1-1-gdeadbee-1
        9.1.2-2-g1234567-1
        10.0.0-1-gabcdef3-1
        10.5.7-2-g21353f0-1
        10.20.2-2-gbbbbbbb-1
        10.20.2-3-gaaaaaaa-1
        9.0.1-2-gdeadbe1-1
        9.0.1-2-gdeadbe1-2
        9.0.1-2-gdeadbe2-1
        9.1.1-2-g1234567-1
      }
    end
    let(:release_build_versions) do
      %w{
        9.0.1-1-gdeadbee-1
        9.1.2-2-g1234567-1
        10.0.0-1-gabcdef3-1
        10.5.7-2-g21353f0-1
        10.20.2-2-gbbbbbbb-1
        10.20.2-3-gaaaaaaa-1
        9.0.1-2-gdeadbe1-1
        9.0.1-2-gdeadbe1-2
        9.0.1-2-gdeadbe2-1
        9.1.1-2-g1234567-1
      }
    end
  end # it_has_behavior

  it_has_behavior "comparable", [
    "9.0.1-1-gdeadbee-1", "9.0.1-2-gdeadbe1-1",
    "9.0.1-2-gdeadbe1-2", "9.0.1-2-gdeadbe2-1",
    "9.1.1-2-g1234567-1", "9.1.2-2-g1234567-1",
    "10.0.0-1-gabcdef3-1", "10.5.7-2-g21353f0-1",
    "10.20.2-2-gbbbbbbb-1", "10.20.2-3-gaaaaaaa-1"
  ]
end # describe
