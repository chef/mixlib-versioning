#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Author:: Christopher Maier (<cm@opscode.com>)
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

module Mixlib
  class Versioning
    class Format
      # Handles version strings based on {http://semver.org/ SemVer 2.0.0-rc.1}.
      #
      # SUPPORTED FORMATS
      # -----------------
      # ```text
      # MAJOR.MINOR.PATCH
      # MAJOR.MINOR.PATCH-PRERELEASE
      # MAJOR.MINOR.PATCH-PRERELEASE+BUILD
      #```
      #
      # EXAMPLES
      # --------
      # ```text
      # 11.0.0
      # 11.0.0-alpha.1
      # 11.0.0-alpha1+20121218164140
      # 11.0.0-alpha1+20121218164140.git.207.694b062
      # ```
      #
      # @author Seth Chisamore (<schisamo@opscode.com>)
      # @author Christopher Maier (<cm@opscode.com>)
      class SemVer < Format

        SEMVER_REGEX = /^(\d+)\.(\d+)\.(\d+)(?:\-([\dA-Za-z\-\.]+))?(?:\+([\dA-Za-z\-\.]+))?$/

        # @see Format#initialize
        def initialize(version)
          match = version.match(SEMVER_REGEX) rescue nil

          unless match
            raise Mixlib::Versioning::ParseError, "'#{version}' is not a valid semver version string!"
          end

          @input = version

          @major, @minor, @patch, @prerelease, @build = match[1..5]
          @major, @minor, @patch = [@major, @minor, @patch].map(&:to_i)

          @prerelease = nil if (@prerelease.nil? || @prerelease.empty?)
          @build = nil if (@build.nil? || @build.empty?)
        end

        # @see Format#to_s
        def to_s
          @input
        end

      end # class SemVer
    end # class Format
  end # module Versioning
end # module Mixlib
