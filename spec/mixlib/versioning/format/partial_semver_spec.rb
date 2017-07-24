#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Author:: Ryan Hass (<rhass@chef.io>)
# Copyright:: Copyright (c) 2017 Chef Software Inc.
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

require "spec_helper"

describe Mixlib::Versioning::Format::PartialSemVer do
  subject { described_class.new(version_string) }

  it_has_behavior "serializable", [
    "1",
    "12",
    "1.2",
    "1.23",
    "12.3",
    "12.34",
  ]

  it_has_behavior "sortable" do
    let(:unsorted_version_strings) do
      %w{
        2
        1.1
        1
        1.0
        2.0
        1.2
      }
    end
    let(:sorted_version_strings) do
      %w{
        1
        1.0
        1.1
        1.2
        2
        2.0
      }
    end
    let(:min) { "1" }
    let(:max) { "2.0" }
  end # it_has_behavior

  it_has_behavior "filterable" do
    let(:unsorted_version_strings) do
      %w{
        2
        1.1
        1
        1.0
        2.0
        1.2
        12.0
        12
      }
    end
    let(:release_versions) do
      %w{
        2.0
        1.1
        1.0
        1.0
        2.0
        1.2
        12.0
        12.0
      }
    end
  end # it_has_behavior

  it_has_behavior "comparable", [
    "1", "2",
    "1", "1.1",
    "1.1", "2",
    "1.1", "1.2"
  ]

  it_has_behavior "comparable_types", [
    "0.1", { value: "1.0.0.pre.1", class: Mixlib::Versioning::Format::Rubygems },
    "0.1", { value: "1.0.0-rc.1", class: Mixlib::Versioning::Format::OpscodeSemVer },
    "1", { value: "1.0.1", class: Mixlib::Versioning::Format::Rubygems },
    "1", { value: "1.0.1", class: Mixlib::Versioning::Format::SemVer },
    "1", { value: "1.0.1", class: Mixlib::Versioning::Format::OpscodeSemVer },
    "1", { value: "1.0.0-1-gdeadbee-1", class: Mixlib::Versioning::Format::GitDescribe },
    "1", { value: "2.0.0", class: Mixlib::Versioning::Format::Rubygems },
    "1", { value: "2.0.0", class: Mixlib::Versioning::Format::SemVer },
    "1", { value: "2.0.0-rc.1", class: Mixlib::Versioning::Format::OpscodeSemVer },
    "1", { value: "2.0.0-1-gdeadbee-1", class: Mixlib::Versioning::Format::GitDescribe },
    "1", { value: "1.1.0", class: Mixlib::Versioning::Format::Rubygems },
    "1", { value: "1.1.0", class: Mixlib::Versioning::Format::SemVer },
    "1", { value: "1.1.0", class: Mixlib::Versioning::Format::OpscodeSemVer },
    "1", { value: "1.1.0-1-gdeadbee-1", class: Mixlib::Versioning::Format::GitDescribe },
    "1.1", { value: "1.1.1", class: Mixlib::Versioning::Format::Rubygems },
    "1.1", { value: "1.1.1", class: Mixlib::Versioning::Format::SemVer },
    "1.1", { value: "1.1.1", class: Mixlib::Versioning::Format::OpscodeSemVer },
    "1.1", { value: "1.1.1-1-gdeadbee-1", class: Mixlib::Versioning::Format::GitDescribe },
    "1.1", { value: "2.0.0", class: Mixlib::Versioning::Format::Rubygems },
    "1.1", { value: "2.0.0", class: Mixlib::Versioning::Format::SemVer },
    "1.1", { value: "2.0.0", class: Mixlib::Versioning::Format::OpscodeSemVer },
    "1.1", { value: "2.0.0-1-gdeadbee-1", class: Mixlib::Versioning::Format::GitDescribe },
    "1.1", { value: "1.2.0", class: Mixlib::Versioning::Format::Rubygems },
    "1.1", { value: "1.2.0", class: Mixlib::Versioning::Format::SemVer },
    "1.1", { value: "1.2.0", class: Mixlib::Versioning::Format::OpscodeSemVer },
    "1.1", { value: "1.2.0-1-gdeadbee-1", class: Mixlib::Versioning::Format::GitDescribe }
  ]
end # describe
