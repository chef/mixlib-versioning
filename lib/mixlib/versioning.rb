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

require 'mixlib/versioning/exceptions'
require 'mixlib/versioning/format'

module Mixlib
  class Versioning

    ###########################################################################
    # Class Methods
    ###########################################################################

    # Select the most recent version from +all_versions+ that satisfies the
    # filtering constraints provided by +filter_version+,
    # +use_prerelease_versions+, and +use_build_versions+.
    #
    # +all_versions+ is an array of +Opscode::Version+ objects.  This is the
    # "world" of versions we will be filtering to produce the final target
    # version.
    #
    # +use_prerelease_versions+ determines whether or not we want to keep or
    # discard versions from +all_versions+ that have pre-release
    # specifiers.
    #
    # +use_build_versions+ determines whether or not we want to keep or discard
    # versions from +all_versions+ that have build specifiers.
    #
    # +filter_version+ is a +Mixlib::Versioning::Format+ (or nil) that provides
    # more fine-grained filtering.
    #
    # If +filter_version+ specifies a release (e.g. 1.0.0), then the target
    # version that is returned will be in the same "release line" (it will have
    # the same major, minor, and patch versions), subject to filtering by
    # +use_prereleases+ and +use_build_versions+.
    #
    # If +filter_version+ specifies a pre-release (e.g., 1.0.0-alpha.1), the
    # returned target version will be in the same "pre-release line", and will
    # only be subject to further filtering by +use_build_versions+; that is,
    # +use_prereleases+ is completely ignored.
    #
    # If +filter_version+ specifies a build version (whether it is a
    # pre-release or not), no filtering is performed at all, and
    # +filter_version+ *is* the target version; +use_prerelease_versions+ and
    # +use_build_versions+ are both ignored.
    #
    # If +filter_version+ is +nil+, then only +use_prereleases+ and
    # +use_build_versions+ are used for filtering.
    #
    # In all cases, the returned +Mixlib::Versioning::Format+ is the most
    # recent one in +all_versions+ that satisfies the given constraints.
    def self.find_target_version(all_versions,
                                 filter_version,
                                 use_prerelease_versions=false,
                                 use_build_versions=false)
      if filter_version && filter_version.build
        # If we've requested a build (whether for a pre-release or release),
        # there's no sense doing any other filtering; just return that version
        filter_version
      elsif filter_version && filter_version.prerelease
        # If we've requested a prerelease version, we only need to see if we
        # want a build version or not.  If so, keep only the build version for
        # that prerelease, and then take the most recent. Otherwise, just
        # return the specified prerelease version
        if use_build_versions
          all_versions.select{|v| v.in_same_prerelease_line?(filter_version)}.max
        else
          filter_version
        end
      else
        # If we've gotten this far, we're either just interested in
        # variations on a specific release, or the latest of all versions
        # (depending on various combinations of prerelease and build status)
        all_versions.select do |v|
          # If we're given a version to filter by, then we're only
          # interested in other versions that share the same major, minor,
          # and patch versions.
          #
          # If we weren't given a version to filter by, then we don't
          # care, and we'll take everything
          in_release_line = if filter_version
                              filter_version.in_same_release_line?(v)
                            else
                              true
                            end

          in_release_line && if use_prerelease_versions && use_build_versions
                               v.prerelease_build?
                             elsif !use_prerelease_versions &&
                                   use_build_versions
                               v.release_build?
                             elsif use_prerelease_versions &&
                                   !use_build_versions
                               v.prerelease?
                             elsif !use_prerelease_versions &&
                                   !use_build_versions
                               v.release?
                             end
        end.max # select the most recent version

      end # if
    end # self.find_target_version

  end # Versioning
end # Mixlib
