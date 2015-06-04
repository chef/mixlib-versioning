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

require 'spec_helper'

describe Mixlib::Versioning::Format do
  describe '#initialize' do
    subject { described_class.new(version_string) }
    let(:version_string) { '11.0.0' }

    it 'descendants must override #parse' do
      expect { subject }.to raise_error
    end
  end

  describe '.for' do
    subject { described_class }

    [
      :rubygems,
      'rubygems',
      Mixlib::Versioning::Format::Rubygems,
    ].each do |format_type|
      context 'format_type is a: #{format_type.class}' do
        let(:format_type) { format_type }
        it 'returns the correct format class' do
          subject.for(format_type).should eq Mixlib::Versioning::Format::Rubygems
        end # it
      end # context
    end # each

    describe 'unknown format_type' do
      [
        :poop,
        'poop',
        Mixlib::Versioning,
      ].each do |invalid_format_type|
        context 'format_type is a: #{invalid_format_type.class}' do
          it 'raises a Mixlib::Versioning::UnknownFormatError' do
            expect { subject.for(invalid_format_type) }.to raise_error(Mixlib::Versioning::UnknownFormatError)
          end # it
        end # context
      end # each
    end # describe
  end # describe ".for"
end # describe Mixlib::Versioning::Format
