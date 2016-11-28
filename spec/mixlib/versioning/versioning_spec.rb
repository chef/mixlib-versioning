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

describe Mixlib::Versioning do
  subject { described_class }

  let(:version_string) { "11.0.0" }

  describe ".parse" do
    describe "parsing when format type is specified" do
      {
        "11.0.8" => {
          format_type: :semver,
          expected_format: Mixlib::Versioning::Format::SemVer,
        },
        "11.1.1" => {
          format_type: :rubygems,
          expected_format: Mixlib::Versioning::Format::Rubygems,
        },
        "11.1.1.alpha.1" => {
          format_type: :rubygems,
          expected_format: Mixlib::Versioning::Format::Rubygems,
        },
        "11.1.1-alpha.1" => {
          format_type: :opscode_semver,
          expected_format: Mixlib::Versioning::Format::OpscodeSemVer,
        },
        "11.1.1-rc.2" => {
          format_type: :opscode_semver,
          expected_format: Mixlib::Versioning::Format::SemVer,
        },
      }.each_pair do |version_string, options|
        context "#{version_string} as #{options[:expected_format]}" do
          let(:version_string) { version_string }
          let(:expected_format) { options[:expected_format] }

          [
            options[:format_type],
            options[:format_type].to_s,
            options[:expected_format],
          ].each do |format_type|
            context "format type as a: #{format_type.class}" do
              it "parses version string as: #{options[:expected_format]}" do
                result = subject.parse(version_string, format_type)
                expect(result).to be_a(expected_format)
              end # it
            end # context
          end # each
        end # context
      end # each_pair

      describe "invalid format type specified" do
        [
          :poop,
          "poop",
          Mixlib::Versioning,
        ].each do |invalid_format_type|
          context "invalid format as a: #{invalid_format_type.class}" do
            it "raises a Mixlib::Versioning::UnknownFormatError" do
              expect { subject.parse(version_string, invalid_format_type) }.to raise_error(Mixlib::Versioning::UnknownFormatError)
            end # it
          end # context
        end # each
      end # describe
    end # describe

    describe "parsing with automatic format detection" do
      {
        "11.0.8" => Mixlib::Versioning::Format::SemVer,
        "11.0.8-1" => Mixlib::Versioning::Format::SemVer,
        "11.0.8.rc.1" => Mixlib::Versioning::Format::Rubygems,
        "11.0.8.rc.1-1" => Mixlib::Versioning::Format::Rubygems,
        "11.0.8-rc.1" => Mixlib::Versioning::Format::OpscodeSemVer,

        "10.18.2" => Mixlib::Versioning::Format::SemVer,
        "10.18.2-poop" => Mixlib::Versioning::Format::SemVer,
        "10.18.2.poop" => Mixlib::Versioning::Format::Rubygems,
        "10.18.2.poop-1" => Mixlib::Versioning::Format::Rubygems,

        "12.1.1+20130311134422" => Mixlib::Versioning::Format::OpscodeSemVer,
        "12.1.1-rc.3+20130311134422" => Mixlib::Versioning::Format::OpscodeSemVer,
        "12.1.1+20130308110833.git.2.94a1dde" => Mixlib::Versioning::Format::OpscodeSemVer,

        "10.16.2-49-g21353f0" => Mixlib::Versioning::Format::GitDescribe,
        "10.16.2-49-g21353f0-1" => Mixlib::Versioning::Format::GitDescribe,
        "10.16.2.rc.2-49-g21353f0" => Mixlib::Versioning::Format::GitDescribe,
        "10.16.2-rc.2-49-g21353f0" => Mixlib::Versioning::Format::GitDescribe,
      }.each_pair do |version_string, expected_format|
        context version_string do
          let(:version_string) { version_string }
          it "parses version string as: #{expected_format}" do
            expect(subject.parse(version_string)).to be_a(expected_format)
          end # it
        end # context
      end # each_pair

      describe "version_string cannot be parsed" do
        let(:version_string) { "A.B.C" }
        it "returns nil" do
          expect(subject.parse(version_string)).to be_nil
        end
      end
    end # describe "parsing with automatic format detection"

    describe "parsing an Mixlib::Versioning::Format object" do
      it "returns the same object" do
        v = Mixlib::Versioning.parse(version_string)
        result = subject.parse(v)
        expect(v).to be result
      end
    end

    describe "when formats are given" do
      context "when the format is not in the list" do
        let(:version_string) { "10.16.2-rc.2-49-g21353f0" }
        it "returns nil when the array contains a Mixlib::Versioning::Format" do
          expect(subject.parse(version_string, [Mixlib::Versioning::Format::Rubygems])).to be_nil
        end

        it "returns nil when the array contains a string" do
          expect(subject.parse(version_string, ["rubygems"])).to be_nil
        end

        it "returns nil when the array contains a symbol" do
          expect(subject.parse(version_string, [:rubygems])).to be_nil
        end
      end

      context "when the format is in the list" do
        let(:version_string) { "10.16.2-rc.2-49-g21353f0" }
        let(:expected_format) { Mixlib::Versioning::Format::GitDescribe }
        it "returns nil when the array contains a Mixlib::Versioning::Format" do
          expect(subject.parse(version_string, [expected_format])).to be_a(expected_format)
        end

        it "returns nil when the array contains a string" do
          expect(subject.parse(version_string, ["git_describe"])).to be_a(expected_format)
        end

        it "returns nil when the array contains a symbol" do
          expect(subject.parse(version_string, [:git_describe])).to be_a(expected_format)
        end
      end
    end
  end # describe .parse

  describe ".find_target_version" do
    let(:all_versions) do
      %w{
        11.0.0-beta.1
        11.0.0-rc.1
        11.0.0
        11.0.1
        11.0.1+2013031116332
        11.0.2-alpha.0
        11.0.2-alpha.0+2013041116332
        11.0.2
      }
    end
    let(:filter_version) { nil }
    let(:use_prerelease_versions) { false }
    let(:use_build_versions) { false }
    let(:subject_find) do
      subject.find_target_version(
        all_versions,
        filter_version,
        use_prerelease_versions,
        use_build_versions
      )
    end

    {
      nil => {
        releases_only: "11.0.2",
        prerelease_versions: "11.0.2-alpha.0",
        build_versions: "11.0.1+2013031116332",
        prerelease_and_build_versions: "11.0.2-alpha.0+2013041116332",
      },
      "11.0.0" => {
        releases_only: "11.0.0",
        prerelease_versions: "11.0.0-rc.1",
        build_versions: nil,
        prerelease_and_build_versions: nil,
      },
      "11.0.2" => {
        releases_only: "11.0.2",
        prerelease_versions: "11.0.2-alpha.0",
        build_versions: nil,
        prerelease_and_build_versions: "11.0.2-alpha.0+2013041116332",
      },
      "11.0.2" => { # rubocop: disable Lint/DuplicatedKey
        releases_only: "11.0.2",
        prerelease_versions: "11.0.2-alpha.0",
        build_versions: nil,
        prerelease_and_build_versions: "11.0.2-alpha.0+2013041116332",
      },
      "11.0.2-alpha.0" => {
        releases_only: "11.0.2-alpha.0",
        prerelease_versions: "11.0.2-alpha.0",
        build_versions: "11.0.2-alpha.0+2013041116332",
        prerelease_and_build_versions: "11.0.2-alpha.0+2013041116332",
      },
    }.each_pair do |filter_version, options|
      context "filter version of: #{filter_version}" do
        let(:filter_version) { filter_version }
        let(:expected_version) { options[:releases_only] }

        it "finds the most recent release version" do
          expect(subject_find).to eq Mixlib::Versioning.parse(expected_version)
        end

        context "include pre-release versions" do
          let(:use_prerelease_versions) { true }
          let(:expected_version) { options[:prerelease_versions] }

          it "finds the most recent pre-release version" do
            expect(subject_find).to eq Mixlib::Versioning.parse(expected_version)
          end # it
        end # context

        context "include build versions" do
          let(:use_build_versions) { true }
          let(:expected_version) { options[:build_versions] }

          it "finds the most recent build version" do
            expect(subject_find).to eq Mixlib::Versioning.parse(expected_version)
          end # it
        end # context

        context "include pre-release and build versions" do
          let(:use_prerelease_versions) { true }
          let(:use_build_versions) { true }
          let(:expected_version) { options[:prerelease_and_build_versions] }

          it "finds the most recent pre-release build version" do
            expect(subject_find).to eq Mixlib::Versioning.parse(expected_version)
          end # it
        end # context
      end # context
    end # each_pair

    describe "all_versions argument is a mix of String and Mixlib::Versioning::Format instances" do
      let(:all_versions) do
        [
          "11.0.0-beta.1",
          "11.0.0-rc.1",
          Mixlib::Versioning.parse("11.0.0"),
        ]
      end

      it "correctly parses the array" do
        expect(subject_find).to eq Mixlib::Versioning.parse("11.0.0")
      end
    end # describe

    describe "filter_version argument is an instance of Mixlib::Versioning::Format" do
      let(:filter_version) { Mixlib::Versioning::Format::SemVer.new("11.0.0") }

      it "finds the correct version" do
        expect(subject_find).to eq Mixlib::Versioning.parse("11.0.0")
      end
    end
  end # describe
end # describe Mixlib::Versioning
