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

require 'mixlib/versioning/format/semver'

module Mixlib
  class Versioning
    class Format
      # Defines the format of the semantic version scheme used for Opscode
      # projects.  They are SemVer-2.0.0-rc.1 compliant, but we further
      # constrain the allowable strings for prerelease and build
      # signifiers for our own internal standards.
      class OpscodeSemVer < SemVer

        # SUPPORTED FORMATS:
        #
        #    MAJOR.MINOR.PATCH
        #    MAJOR.MINOR.PATCH-alpha.INDEX
        #    MAJOR.MINOR.PATCH-beta.INDEX
        #    MAJOR.MINOR.PATCH-rc.INDEX
        #    MAJOR.MINOR.PATCH-alpha.INDEX+YYYYMMDDHHMMSS
        #    MAJOR.MINOR.PATCH-beta.INDEX+YYYYMMDDHHMMSS
        #    MAJOR.MINOR.PATCH-rc.INDEX+YYYYMMDDHHMMSS
        #    MAJOR.MINOR.PATCH-alpha.INDEX+YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1
        #    MAJOR.MINOR.PATCH-beta.INDEX+YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1
        #    MAJOR.MINOR.PATCH-rc.INDEX+YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1
        #
        # EXAMPLES:
        #
        #    11.0.0
        #    11.0.0-alpha.1
        #    11.0.0-alpha1+20121218164140
        #    11.0.0-alpha1+20121218164140.git.207.694b062
        #

        # The pattern is: YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1
        OPSCODE_BUILD_REGEX = /^\d{14}(\.git\.\d+\.[a-f0-9]{7})?$/

        # Allows the following:
        #
        # alpha, alpha.0, alpha.1, alpha.2, etc.
        # beta, beta.0, beta.1, beta.2, etc.
        # rc, rc.0, rc.1, rc.2, etc.
        #
        # TODO: Should we allow bare prerelease tags like "alpha", "beta", and "rc", without a number?
        OPSCODE_PRERELEASE_REGEX = /^(alpha|beta|rc)(\.\d+)?$/

        def initialize(version)
          super(version)

          unless @prerelease.nil?
            unless @prerelease.match(OPSCODE_PRERELEASE_REGEX)
              raise Mixlib::Versioning::ParseError, "'#{@prerelease}' is not a valid Opscode prerelease signifier"
            end
          end

          unless @build.nil?
            unless @build.match(OPSCODE_BUILD_REGEX)
              raise Mixlib::Versioning::ParseError, "'#{@build}' is not a valid Opscode build signifier"
            end
          end
        end
      end
    end
  end
end
