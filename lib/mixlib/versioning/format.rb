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

require 'mixlib/versioning/format/git_describe'
require 'mixlib/versioning/format/opscode_semver'
require 'mixlib/versioning/format/rubygems'
require 'mixlib/versioning/format/semver'

module Mixlib
  class Versioning
    class Format
      include Comparable

      attr_reader :major, :minor, :patch, :prerelease, :build, :iteration

      def initialize(version)
        raise Error, "You must override the initializer!"
      end

      # Is this an official release?
      def release?
        @prerelease.nil? && @build.nil?
      end

      # Is this an official pre-release? (i.e., not a build version)
      def prerelease?
        !!(@prerelease && @build.nil?)
      end

      # Is this a build version of a release?
      def release_build?
        !!(@prerelease.nil? && @build)
      end

      # Is this a build version of a pre-release?
      def prerelease_build?
        !!(@prerelease && @build)
      end

      # Is this a build (either of a release or a pre-release)?
      def build?
        !!@build
      end

      # Returns +true+ if +other+ and this +Version+ share the same
      # major, minor, and patch values.  Prerelease and build specifiers
      # are not taken into consideration.
      def in_same_release_line?(other)
        @major == other.major &&
        @minor == other.minor &&
        @patch == other.patch
      end

      # Returns +true+ if +other+ and this +Version+ share the same
      # major, minor, patch, and prerelease values.  Build specifiers
      # are not taken into consideration.
      def in_same_prerelease_line?(other)
        @major == other.major &&
        @minor == other.minor &&
        @patch == other.patch &&
        @prerelease == other.prerelease
      end

      def to_s
        raise Error, "You must override #to_s"
      end

      # TODO - create a proper serialization abstraction
      def to_semver_string
        s = [@major, @minor, @patch].join(".")
        s += "-#{@prerelease}" if @prerelease
        s += "+#{@build}" if @build
        s
      end

      def to_rubygems_string
        s = [@major, @minor, @patch].join(".")
        s += ".#{@prerelease}" if @prerelease
        s
      end

      def <=>(other)

        # First, perform comparisons based on major, minor, and patch
        # versions.  These are always presnt and always non-nil
        maj = @major <=> other.major
        return maj unless maj == 0

        min = @minor <=> other.minor
        return min unless min == 0

        pat = @patch <=> other.patch
        return pat unless pat == 0

        # Next compare pre-release specifiers.  A pre-release sorts
        # before a release (e.g. 1.0.0-alpha.1 comes before 1.0.0), so
        # we need to take nil into account in our comparison.
        #
        # If both have pre-release specifiers, we need to compare both
        # on the basis of each component of the specifiers.
        if @prerelease && other.prerelease.nil?
          return -1
        elsif @prerelease.nil? && other.prerelease
          return 1
        elsif @prerelease && other.prerelease
          pre = compare_dot_components(@prerelease, other.prerelease)
          return pre unless pre == 0
        end

        # Build specifiers are compared like pre-release specifiers,
        # except that builds sort *after* everything else
        # (e.g. 1.0.0+build.123 comes after 1.0.0, and
        # 1.0.0-alpha.1+build.123 comes after 1.0.0-alpha.1)
        if @build.nil? && other.build
          return -1
        elsif @build && other.build.nil?
          return 1
        elsif @build && other.build
          build_ver = compare_dot_components(@build, other.build)
          return build_ver unless build_ver == 0
        end

        # Some older version formats improperly include a package iteration in
        # the version string. This is different than a build specifier and
        # valid release versions may include an iteration. We'll transparently
        # handle this case and compare iterations if it was parsed by the
        # implementation class.
        if @iteration.nil? && other.iteration
          return -1
        elsif @iteration && other.iteration.nil?
          return 1
        elsif @iteration && other.iteration
          return @iteration <=> other.iteration
        end

        # If we get down here, they're both equal
        return 0
      end

      def eql?(other)
        @major == other.major &&
          @minor == other.minor &&
          @patch == other.patch &&
          @prerelease == other.prerelease &&
          @build == other.build
      end

      def hash
        [@major, @minor, @patch, @prerelease, @build].compact.join(".").hash
      end

      ###########################################################################

      private

      # If a String +n+ can be parsed as an Integer do so; otherwise, do
      # nothing.
      #
      # (+nil+ is a valid input.)
      def maybe_int(n)
        Integer(n)
      rescue
        n
      end

      # Compares prerelease and build version component strings
      # according to semver 2.0.0-rc.1 semantics.
      #
      # Returns -1, 0, or 1, just like the spaceship operator (+<=>+),
      # and is used in the implemntation of +<=>+ for this class.
      #
      # Prerelease and build specifiers are dot-separated strings.
      # Numeric components are sorted numerically; otherwise, sorting is
      # standard ASCII order.  Numerical components have a lower
      # precedence than string components.
      #
      # See http://www.semver.org for more.
      #
      # Both +a_item+ and +b_item+ should be Strings; +nil+ is not a
      # valid input.
      def compare_dot_components(a_item, b_item)
        a_components = a_item.split(".")
        b_components = b_item.split(".")

        max_length = [a_components.length, b_components.length].max

        (0..(max_length-1)).each do |i|
          # Convert the ith component into a number if possible
          a = maybe_int(a_components[i])
          b = maybe_int(b_components[i])

          # Since the components may be of differing lengths, the
          # shorter one will yield +nil+ at some point as we iterate.
          if a.nil? && !b.nil?
            # a_item was shorter
            return -1
          elsif !a.nil? && b.nil?
            # b_item was shorter
            return 1
          end

          # Now we need to compare appropriately based on type.
          #
          # Numbers have lower precedence than strings; therefore, if
          # the components are of differnt types (String vs. Integer),
          # we just return -1 for the numeric one and we're done.
          #
          # If both are the same type (Integer vs. Integer, or String
          # vs. String), we can just use the native comparison.
          #
          if a.is_a?(Integer) && b.is_a?(String)
            # a_item was "smaller"
            return -1
          elsif a.is_a?(String) && b.is_a?(Integer)
            # b_item was "smaller"
            return 1
          else
            comp = a <=> b
            return comp unless comp == 0
          end
        end # each

        # We've compared all components of both strings; if we've gotten
        # down here, they're totally the same
        return 0
      end
    end
  end
end
