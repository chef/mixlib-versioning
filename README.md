# Mixlib::Versioning

Versioning is hard! `mixlib-versioning` is a general Ruby library that allows
you to parse, compare and manipulate version numbers in multiple formats.
Currently the following version string formats are supported:

### SemVer 2.0.0-rc.1

**Specification:**

http://semver.org/

**Supported Formats:**

```text
MAJOR.MINOR.PATCH
MAJOR.MINOR.PATCH-PRERELEASE
MAJOR.MINOR.PATCH-PRERELEASE+BUILD
```

Not much to say here except: *YUNO USE SEMVER!* The specification is focused and
brief, do yourself a favor and go read it.

### Opscode SemVer

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

All the fun of regular SemVer with some extra limits around what constitutes a
valid pre-release or build version string.

Valid prerelease version strings use the format: `PRERELEASE_STAGE.INDEX`.
Valid prerelease stages include: `alpha`, `beta` and `rc`.

All of the following are acceptable Opscode SemVer pre-release versions:

```text
11.0.8-alpha.0
11.0.8-alpha.1
11.0.8-beta.7
11.0.8-beta.8
11.0.8-rc.1
11.0.8-rc.2
```

Build version strings are limited to timestamps (`YYYYMMDDHHMMSS`), git
describe strings (`git.COMMITS_SINCE.SHA1`) or a combination of the two
(`YYYYMMDDHHMMSS.git.COMMITS_SINCE.SHA1`).

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

### Rubygems

**specification:**

http://docs.rubygems.org/read/chapter/7

http://guides.rubygems.org/patterns/

**Supported Formats:**

```text
MAJOR.MINOR.PATCH
MAJOR.MINOR.PATCH.PRERELEASE
```

Rubygems is *almost* SemVer compliant but it separates the main version from
the pre-release version using a "dot". It also does not have the notion of a
build version like SemVer.

Examples of valid Rubygems version strings:

```text
10.1.1
10.1.1
10.1.1.alpha.1
10.1.1.beta.1
10.1.1.rc.0
```

### Git Describe

**Specification:**

http://git-scm.com/docs/git-describe

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

## Installation

Add this line to your application's Gemfile:

    gem 'mixlib-versioning'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mixlib-semver

## Usage

TODO

## Contributing

TODO

## Reporting Bugs

You can search for known issues in
[Opscode's bug tracker][jira]. Tickets should be filed under the **MIXLIB**
project with the component set to **"mixlib-versioning"**.

## License

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Copyright:**       | Copyright (c) 2013 Opscode, Inc.
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[jira]: http://tickets.opscode.com/browse/MIXLIB
