# Mixlib::Versioning

[![Build Status](https://travis-ci.org/chef/mixlib-versioning.svg?branch=master)](https://travis-ci.org/chef/mixlib-versioning) [![Code Climate](https://codeclimate.com/github/chef/mixlib-versioning.svg)](https://codeclimate.com/github/chef/mixlib-versioning)

This project is managed by the CHEF Release Engineering team. For more information on the Release Engineering team's contribution, triage, and release process, please consult the [CHEF Release Engineering OSS Management Guide](https://docs.google.com/a/chef.io/document/d/1oJB0vZb_3bl7_ZU2YMDBkMFdL-EWplW1BJv_FXTUOzg/edit).

Versioning is hard! `mixlib-versioning` is a general Ruby library that allows you to parse, compare and manipulate version numbers in multiple formats. Currently the following version string formats are supported:

## SemVer 2.0.0

**Specification:**

<http://semver.org/>

**Supported Formats:**

```text
MAJOR.MINOR.PATCH
MAJOR.MINOR.PATCH-PRERELEASE
MAJOR.MINOR.PATCH-PRERELEASE+BUILD
```

Not much to say here except: _YUNO USE SEMVER!_ The specification is focused and brief, do yourself a favor and go read it.

## Opscode SemVer

**Supported Formats:**

```text
MAJOR.MINOR.PATCH
MAJOR.MINOR.PATCH-alpha.INDEX
MAJOR.MINOR.PATCH-beta.INDEX
MAJOR.MINOR.PATCH-rc.INDEX
MAJOR.MINOR.PATCH-alpha.INDEX+YYYYMMDDHHMMSS
MAJOR.MINOR.PATCH-beta.INDEX+YYYYMMDDHHMMSS
MAJOR.MINOR.PATCH-rc.INDEX+YYYYMMDDHHMMSS
MAJOR.MINOR.PATCH-alpha.INDEX+YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1
MAJOR.MINOR.PATCH-beta.INDEX+YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1
MAJOR.MINOR.PATCH-rc.INDEX+YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1
```

All the fun of regular SemVer with some extra limits around what constitutes a valid pre-release or build version string.

Valid prerelease version strings use the format: `PRERELEASE_STAGE.INDEX`. Valid prerelease stages include: `alpha`, `beta` and `rc`.

All of the following are acceptable Opscode SemVer pre-release versions:

```text
11.0.8-alpha.0
11.0.8-alpha.1
11.0.8-beta.7
11.0.8-beta.8
11.0.8-rc.1
11.0.8-rc.2
```

Build version strings are limited to timestamps (`YYYYMMDDHHMMSS`), git describe strings (`git.COMMITS_SINCE.SHA1`) or a combination of the two (`YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1`).

All of the following are acceptable Opscode build versions:

```text
11.0.8+20130308110833
11.0.8+git.2.g94a1dde
11.0.8+20130308110833.git.2.94a1dde
```

And as is true with regular SemVer you can mix pre-release and build versions:

```text
11.0.8-rc.1+20130308110833
11.0.8-alpha.2+20130308110833.git.2.94a1dde
```

## Rubygems

**specification:**

<http://docs.rubygems.org/read/chapter/7>

<http://guides.rubygems.org/patterns/>

**Supported Formats:**

```text
MAJOR.MINOR.PATCH
MAJOR.MINOR.PATCH.PRERELEASE
```

Rubygems is _almost_ SemVer compliant but it separates the main version from the pre-release version using a "dot". It also does not have the notion of a build version like SemVer.

Examples of valid Rubygems version strings:

```text
10.1.1
10.1.1
10.1.1.alpha.1
10.1.1.beta.1
10.1.1.rc.0
```

## Git Describe

**Specification:**

<http://git-scm.com/docs/git-describe>

**Supported Formats:**

```text
MAJOR.MINOR.PATCH-COMMITS_SINCE-gGIT_SHA1
MAJOR.MINOR.PATCH-COMMITS_SINCE-gGIT_SHA1-ITERATION
MAJOR.MINOR.PATCH-PRERELEASE-COMMITS_SINCE-gGIT_SHA1
MAJOR.MINOR.PATCH-PRERELEASE-COMMITS_SINCE-gGIT_SHA1-ITERATION
```

Examples of valid Git Describe version strings:

```text
10.16.2-49-g21353f0-1
10.16.2.rc.1-49-g21353f0-1
11.0.0-alpha-10-g642ffed
11.0.0-alpha.1-1-gcea071e
```


## SemVer Partial


```text
MAJOR
MAJOR.MINOR
```

Examples of valid SemVer Partial version strings:

```text
1
0.1
1.0
```

## Installation

Add this line to your application's Gemfile:

```
gem 'mixlib-versioning'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install mixlib-semver
```

## Usage

### Basic Version String Parsing

```irb
>> require 'mixlib/versioning'
true
>> v1 = Mixlib::Versioning.parse("11.0.3")
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3fecddccff4c @major=11, @minor=0, @patch=3, @prerelease=nil, @build=nil, @input="11.0.3">
>> v1.release?
true
>> v1.prerelease?
false
>> v1.build?
false
>> v1.prerelease_build?
false
>> v2 = Mixlib::Versioning.parse("11.0.0-beta.1")
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3fecde44f420 @major=11, @minor=0, @patch=0, @prerelease="beta.1", @build=nil, @input="11.0.0-beta.1">
>> v2.release?
false
>> v2.prerelease?
true
>> v2.build?
false
>> v2.prerelease_build?
false
>> v3 = Mixlib::Versioning.parse("11.0.6+20130216075209")
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3fecde49568c @major=11, @minor=0, @patch=6, @prerelease=nil, @build="20130216075209", @input="11.0.6+20130216075209">
>> v3.release?
false
>> v3.prerelease?
false
>> v3.build?
true
>> v3.prerelease_build?
false
>> v4 = Mixlib::Versioning.parse("11.0.8-rc.1+20130302083119")
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3fecde4dad7c @major=11, @minor=0, @patch=8, @prerelease="rc.1", @build="20130302083119", @input="11.0.8-rc.1+20130302083119">
>> v4.release?
false
>> v4.prerelease?
false
>> v4.build?
true
>> v4.prerelease_build?
true
>> v5 = Mixlib::Versioning.parse("10.16.8.alpha.0")
#<Mixlib::Versioning::Format::Rubygems:0x3fecde532bd0 @major=10, @minor=16, @patch=8, @prerelease="alpha.0", @iteration=0, @input="10.16.8.alpha.0">
>> v5.major
10
>> v5.minor
16
>> v5.patch
8
>> v5.prerelease
"alpha.0"
>> v5.release?
false
>> v5.prerelease?
true
```

### Version Comparison and Sorting

```irb
>> require 'mixlib/versioning'
true
>> v1 = Mixlib::Versioning.parse("11.0.0-beta.1")
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ff009cd54e0 @major=11, @minor=0, @patch=0, @prerelease="beta.1", @build=nil, @input="11.0.0-beta.1">
>> v2 = Mixlib::Versioning.parse("11.0.0-rc.1")
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ff009d07260 @major=11, @minor=0, @patch=0, @prerelease="rc.1", @build=nil, @input="11.0.0-rc.1">
>> v3 = Mixlib::Versioning.parse("11.0.0")
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ff009d0d3cc @major=11, @minor=0, @patch=0, @prerelease=nil, @build=nil, @input="11.0.0">
>> v1 < v2
true
>> v3 < v1
false
>> v1 == v2
false
>> [v3, v1, v2].sort
[
  [0] #<Mixlib::Versioning::Format::OpscodeSemVer:0x3ff009cd54e0 @major=11, @minor=0, @patch=0, @prerelease="beta.1", @build=nil, @input="11.0.0-beta.1">,
  [1] #<Mixlib::Versioning::Format::OpscodeSemVer:0x3ff009d07260 @major=11, @minor=0, @patch=0, @prerelease="rc.1", @build=nil, @input="11.0.0-rc.1">,
  [2] #<Mixlib::Versioning::Format::OpscodeSemVer:0x3ff009d0d3cc @major=11, @minor=0, @patch=0, @prerelease=nil, @build=nil, @input="11.0.0">
]
>> [v3, v1, v2].map { |v| v.to_s}.sort
[
  [0] "11.0.0",
  [1] "11.0.0-beta.1",
  [2] "11.0.0-rc.1"
]
```

### Target Version Selection

Basic usage:

```ruby
>> require 'mixlib/versioning'
true
>> all_versions = %w{
  11.0.0-alpha.1
  11.0.0-alpha.1-1-gcea071e
  11.0.0-alpha.3+20130103213604.git.11.3fe70b5
  11.0.0-alpha.3+20130129075201.git.38.3332a80
  11.0.0-alpha.3+20130130075202.git.38.3332a80
  11.0.0-beta.0+20130131044557
  11.0.0-beta.1+20130201023059.git.5.c9d3320
  11.0.0-beta.2+20130201035911
  11.0.0-beta.2+20130201191308.git.4.9aa4cb2
  11.0.0-rc.1
  11.0.0+20130204053034.git.1.1802643
  11.0.4
  11.0.6-alpha.0+20130208045134.git.2.298c401
  11.0.6-alpha.0+20130214075209.git.11.5d72e1c
  11.0.6-alpha.0+20130215075208.git.11.5d72e1c
  11.0.6-rc.0
  11.0.6
  11.0.6+20130216075209
  11.0.6+20130221075213
  11.0.8-rc.1
  11.0.8-rc.1+20130302083119
  11.0.8-rc.1+20130304083118
  11.0.8-rc.1+20130305083118
  11.0.8-rc.1+20130305195925.git.2.94a1dde
  11.0.8-rc.1+20130306083036.git.2.94a1dde
  11.0.8-rc.1+20130319083111.git.6.dc8613e
};''
""
>> Mixlib::Versioning.find_target_version(all_versions, "11.0.6", false, false)
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ffdc91364a4 @major=11, @minor=0, @patch=6, @prerelease=nil, @build=nil, @input="11.0.6">
>> target = Mixlib::Versioning.find_target_version(all_versions, "11.0.6", false, false)
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ffdc91364a4 @major=11, @minor=0, @patch=6, @prerelease=nil, @build=nil, @input="11.0.6">
>> target.to_s
"11.0.6"
```

Select latest release version:

```irb
>> target = Mixlib::Versioning.find_target_version(all_versions, nil, false, false)
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ffdc91364a4 @major=11, @minor=0, @patch=6, @prerelease=nil, @build=nil, @input="11.0.6">
>> target.to_s
"11.0.6"
```

Select latest pre-release version:

```irb
>> target = Mixlib::Versioning.find_target_version(all_versions, nil, true, false)
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ffdc9139078 @major=11, @minor=0, @patch=8, @prerelease="rc.1", @build=nil, @input="11.0.8-rc.1">
>> target.to_s
"11.0.8-rc.1"
```

Select the latest release build version:

```irb
>> target = Mixlib::Versioning.find_target_version(all_versions, nil, false, true)
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ffdc91f0bb0 @major=11, @minor=0, @patch=6, @prerelease=nil, @build="20130221075213", @input="11.0.6+20130221075213">
>> target.to_s
"11.0.6+20130221075213"
```

Select the latest pre-release build version:

```irb
>> target = Mixlib::Versioning.find_target_version(all_versions, nil, true, true)
#<Mixlib::Versioning::Format::OpscodeSemVer:0x3ffdc91f154c @major=11, @minor=0, @patch=8, @prerelease="rc.1", @build="20130319083111.git.6.dc8613e", @input="11.0.8-rc.1+20130319083111.git.6.dc8613e">
>> target.to_s
"11.0.8-rc.1+20130319083111.git.6.dc8613e"
```

## How to Run the Tests

To run the unit tests, run

```
rake spec
```

## Documentation

All documentation is written using YARD. You can generate a by running:

```
rake yard
```

## Contributing

For information on contributing to this project see <https://github.com/chef/chef/blob/master/CONTRIBUTING.md>

## License

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | Seth Chisamore (schisamo@chef.io)
| **Author:**          | Christopher Maier (cm@chef.io)
| **Copyright:**       | Copyright (c) 2013-2017 Chef Software, Inc.
| **License:**         | Apache License, Version 2.0

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
