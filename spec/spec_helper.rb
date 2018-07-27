#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Copyright:: Copyright (c) 2013-2018 Chef Software, Inc.
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

require "mixlib/versioning"
require "rspec/its"

# load all shared examples and shared contexts
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each do |file|
  require(file)
end

RSpec.configure do |config|
  # a little syntactic sugar
  config.alias_it_should_behave_like_to :it_has_behavior, "has behavior:"

  # Use documentation format
  config.formatter = "doc"

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # run the examples in random order
  config.order = :rand

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.warnings = true
end
