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

shared_examples "parses valid version strings" do |valid_examples|
  valid_examples.each do |version, options|
    context version do
      let(:version_string) { version }

      options.each_pair do |name, value|
        its(name) { should eq value }
      end
    end # context
  end # valid_examples
end # shared_examples
