#
# Author:: Krzysztof Wilczynski (<kwilczynski@chef.io>)
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
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

shared_examples "comparable" do |version_matrix|
  describe "#<" do
    version_matrix.each_slice(2) do |a, b|
      it "confirms that #{a} is less-than #{b}" do
        expect(described_class.new(a) < b).to be true
        expect(b < described_class.new(a)).to be false
      end
    end
  end

  describe "#<=" do
    version_matrix.each_slice(2) do |a, b|
      it "confirms that #{a} less-than or equal to #{b}" do
        expect(described_class.new(a) <= b).to be true
        expect(described_class.new(a) <= a).to be true
        expect(b <= described_class.new(a)).to be false
        expect(b < described_class.new(a)).to be false
      end
    end
  end

  describe "#==" do
    version_matrix.each do |v|
      it "confirms that #{v} is equal to #{v}" do
        expect(described_class.new(v) == v).to be true
        expect(described_class.new(v) < v).to be false
        expect(described_class.new(v) > v).to be false
      end
    end
  end

  describe "#>" do
    version_matrix.reverse.each_slice(2) do |a, b|
      it "confirms that #{a} is greather-than #{b}" do
        expect(described_class.new(a) > b).to be true
        expect(b > described_class.new(a)).to be false
      end
    end
  end

  describe "#>=" do
    version_matrix.reverse.each_slice(2) do |a, b|
      it "confirms that #{a} greater-than or equal to #{b}" do
        expect(described_class.new(a) >= b).to be true
        expect(described_class.new(a) >= a).to be true
        expect(b >= described_class.new(a)).to be false
        expect(b > described_class.new(a)).to be false
      end
    end
  end

  describe "#between?" do
    let(:versions) { version_matrix.map { |v| described_class.new(v) }.sort }

    it "comfirms that a version is between the oldest and latest release" do
      min, max = versions.minmax.map(&:to_s)
      middle = versions[versions.size / 2].to_s
      expect(described_class.new(middle).between?(min, max)).to be true
      expect(described_class.new(middle).between?(max, min)).to be false
    end
  end
end
