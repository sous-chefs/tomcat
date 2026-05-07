# Migration Guide

This release is a full custom resource migration.

## Breaking Changes

* The cookbook root `recipes/` directory has been removed.
* The cookbook root `attributes/` directory is not supported.
* Upstart service management has been removed.
* `tomcat_service` is systemd-only.
* Template-based service properties have been replaced by generated `systemd_unit` content and the
  `unit_content` override property.

## Before

Older wrapper cookbooks could include the default recipe, then rely on cookbook templates or
platform init selection:

```ruby
include_recipe 'tomcat'
```

## After

Declare the resources directly:

```ruby
tomcat_install 'default' do
  version '9.0.117'
end

tomcat_service 'default' do
  action [:enable, :start]
end
```

## Service Customization

Use `env_vars`, `service_vars`, or `unit_content` instead of upstart/systemd template properties.

```ruby
tomcat_service 'app' do
  env_vars [
    { 'CATALINA_BASE' => '/opt/tomcat_app' },
    { 'CATALINA_PID' => '/opt/tomcat_app/bin/tomcat.pid' },
  ]
  service_vars [
    { 'RestartSec' => 5 },
  ]
  action [:enable, :start]
end
```

See `test/cookbooks/test/recipes/default.rb` for the maintained integration example.
