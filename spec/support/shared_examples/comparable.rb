#
# Author:: Yvonne Lam (<yvonne.getchef.com>)
# Copyright:: Copyright (c) 2013 Chef Software, Inc.
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

require 'mixlib/versioning'

describe Mixlib::Versioning::Format::SemVer do
  context "comparisons" do
    before(:each) do
      @v4_3_2_rc_1_build_1216 = Mixlib::Versioning.parse("4.3.2-rc.1+1216")
      @v4_3_2_rc_1_build_1117 = Mixlib::Versioning.parse("4.3.2-rc.1+1117")
      @v4_3_2_rc_1 = Mixlib::Versioning.parse("4.3.2-rc.1")
      @v4_3_2 = Mixlib::Versioning.parse("4.3.2")
    end

    it "determines equality" do
      (@v4_3_2_rc_1_build_1216.eql?(@v4_3_2_rc_1_build_1117)).should == true
      (@v4_3_2_rc_1_build_1216.eql?(@v4_3_2_rc_1)).should == true
      (@v4_3_2_rc_1_build_1117.eql?(@v4_3_2)).should == false 
    end	
  end
	
end