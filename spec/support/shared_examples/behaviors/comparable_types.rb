#
# Author:: Krzysztof Wilczynski (<kwilczynski@chef.io>)
# Author:: Ryan Hass (<rhass@chef.io>)
# Copyright:: Copyright (c) 2014, 2017 Chef Software Inc.
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

shared_examples "comparable_types" do |version_matrix|
  describe "#<" do
    version_matrix.each_slice(2) do |a, b|
      it "confirms that #{a} is less-than #{b}" do
        expect(described_class.new(a) < b[:class].new(b[:value])).to be true
        expect(b[:class].new(b[:value]) < described_class.new(a)).to be false
      end
    end
  end

  describe "#<=" do
    version_matrix.each_slice(2) do |a, b|
      it "confirms that #{a} less-than or equal to #{b}" do
        expect(described_class.new(a) <= b[:class].new(b[:value])).to be true
        expect(b[:class].new("#{b[:value]}") <= described_class.new(a)).to be false
      end
    end
  end

  describe "#>" do
    version_matrix.each_slice(2) do |a, b|
      it "confirms that #{a} is greater-than #{b}" do
        expect(b[:class].new(b[:value]) > described_class.new(a)).to be true
        expect(described_class.new(a) > b[:class].new(b[:value])).to be false
      end
    end
  end

  describe "#>=" do
    version_matrix.each_slice(2) do |a, b|
      it "confirms that #{a} greater-than or equal to #{b}" do
        expect(b[:class].new(b[:value]) >= described_class.new(a)).to be true
        expect(described_class.new(a) >= b[:class].new(b[:value])).to be false
      end
    end
  end
end
