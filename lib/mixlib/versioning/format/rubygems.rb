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
      # Handles version strings based on {http://guides.rubygems.org/patterns/}
      #
      # SUPPORTED FORMATS
      # -----------------
      # ```text
      # MAJOR.MINOR.PATCH.PRERELEASE
      # MAJOR.MINOR.PATCH.PRERELEASE-ITERATION
      # ```
      #
      # EXAMPLES
      # --------
      # ```text
      # 10.1.1
      # 10.1.1.alpha.1
      # 10.1.1.beta.1
      # 10.1.1.rc.0
      # 10.16.2
      # ```
      #
      # @author Seth Chisamore (<schisamo@opscode.com>)
      # @author Christopher Maier (<cm@opscode.com>)
      class Rubygems < Format

        RUBYGEMS_REGEX = /^(\d+)\.(\d+)\.(\d+)(?:\.([[:alnum:]]+(?:\.[[:alnum:]]+)?))?(?:\-(\d+))?$/

        # @see Format#initialize
        def initialize(version)
          match = version.match(RUBYGEMS_REGEX) rescue nil

          unless match
            raise Mixlib::Versioning::ParseError, "'#{version}' is not a valid Rubygems version string!"
          end

          @input = version

          @major, @minor, @patch, @prerelease, @iteration = match[1..5]
          @major, @minor, @patch, @iteration = [@major, @minor, @patch, @iteration].map(&:to_i)

          # Do not convert @build to an integer; SemVer sorting logic will handle the conversion
          @prerelease = nil if (@prerelease.nil? || @prerelease.empty?)
        end

        # @see Format#to_s
        def to_s
          @input
        end

      end # class Rubygems
    end # class Format
  end # module Versioning
end # module Mixlib
