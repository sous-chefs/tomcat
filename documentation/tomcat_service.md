# tomcat_service

Manages a Tomcat instance as a systemd service.

## Actions

| Action     | Description                                    |
|------------|------------------------------------------------|
| `:create`  | Creates the systemd unit. Default action.      |
| `:start`   | Creates and starts the systemd unit.           |
| `:stop`    | Stops the systemd unit.                        |
| `:restart` | Restarts the systemd unit.                     |
| `:enable`  | Creates and enables the systemd unit.          |
| `:disable` | Disables the systemd unit.                     |
| `:delete`  | Stops, disables, and deletes the systemd unit. |

## Properties

| Property        | Type               | Default                                     | Description                                  |
|-----------------|--------------------|---------------------------------------------|----------------------------------------------|
| `instance_name` | String             | name property                               | Tomcat instance name.                        |
| `install_path`  | String             | `/opt/tomcat_INSTANCE`                      | Tomcat install or symlink path.              |
| `tomcat_user`   | String             | `tomcat_INSTANCE`                           | User the service runs as.                    |
| `tomcat_group`  | String             | `tomcat_INSTANCE`                           | Group the service runs as.                   |
| `service_name`  | String             | `tomcat_INSTANCE`                           | systemd service name without `.service`.     |
| `env_vars`      | Array              | `CATALINA_PID=$CATALINA_BASE/bin/tomcat.pid` | Environment entries for the unit.            |
| `service_vars`  | Array              | `[]`                                        | Additional systemd `[Service]` directives.   |
| `unit_content`  | Hash, String, nil  | `nil`                                       | Full custom systemd unit content.            |

## Examples

### Start And Enable

```ruby
tomcat_service 'default' do
  action [:enable, :start]
end
```

### Custom Environment

```ruby
tomcat_service 'app' do
  install_path '/opt/tomcat_app'
  env_vars [
    { 'CATALINA_BASE' => '/opt/tomcat_app' },
    { 'CATALINA_PID' => '/opt/tomcat_app/bin/tomcat.pid' },
    { 'JAVA_OPTS' => '-Xms512m -Xmx512m' },
  ]
  action [:enable, :start]
end
```

### Custom Unit Content

```ruby
tomcat_service 'app' do
  unit_content(
    Unit: {
      Description: 'Custom Tomcat',
      After: 'network.target',
    },
    Service: {
      Type: 'forking',
      ExecStart: '/opt/tomcat_app/bin/catalina.sh start',
      ExecStop: '/opt/tomcat_app/bin/catalina.sh stop',
      User: 'tomcat_app',
      Group: 'tomcat_app',
    },
    Install: {
      WantedBy: 'multi-user.target',
    }
  )
end
```
