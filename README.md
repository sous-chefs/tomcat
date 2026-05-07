# tomcat Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/tomcat.svg?style=flat)](https://supermarket.chef.io/cookbooks/tomcat)
[![CI State](https://github.com/sous-chefs/tomcat/workflows/ci/badge.svg)](https://github.com/sous-chefs/tomcat/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Provides custom resources for installing Apache Tomcat from upstream tarballs and managing Tomcat
instances with systemd.

## Requirements

### Platforms

See [LIMITATIONS.md](LIMITATIONS.md) for current platform and Tomcat version constraints.

### Chef

Chef Infra Client 15.3 or later.

### Cookbooks

None.

## Usage

This cookbook no longer ships public recipes or node attributes. Use the resources directly from a
wrapper cookbook or test cookbook recipe.

```ruby
tomcat_install 'default' do
  version '9.0.117'
end

tomcat_service 'default' do
  action [:enable, :start]
end
```

For migration guidance from older recipe or template-based usage, see [migration.md](migration.md).

## Resources

* [tomcat_install](documentation/tomcat_install.md)
* [tomcat_service](documentation/tomcat_service.md)

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
