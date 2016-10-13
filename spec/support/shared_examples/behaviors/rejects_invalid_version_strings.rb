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

shared_examples "rejects invalid version strings" do |invalid_examples|
  invalid_examples.each_pair do |version, reason|
    context version do
      let(:version_string) { version }

      it "fails because: #{reason}" do
        expect { subject }.to raise_error(Mixlib::Versioning::ParseError)
      end
    end # context
  end # invalid_examples
end # shared_examples
