# tomcat_install

Installs an Apache Tomcat instance from an upstream tarball.

## Actions

| Action     | Description                                      |
|------------|--------------------------------------------------|
| `:install` | Installs Tomcat. Default action.                 |
| `:delete`  | Removes the install directory, symlink, tarball. |

## Properties

| Property                | Type             | Default                                            | Description                                      |
|-------------------------|------------------|----------------------------------------------------|--------------------------------------------------|
| `instance_name`         | String           | name property                                      | Tomcat instance name.                            |
| `version`               | String           | `'9.0.117'`                                        | Tomcat version to install.                       |
| `version_archive`       | String           | `apache-tomcat-VERSION.tar.gz`                     | Archive filename.                                |
| `install_path`          | String           | `/opt/tomcat_INSTANCE_VERSION/`                    | Install directory.                               |
| `tarball_base_uri`      | String           | `'http://archive.apache.org/dist/tomcat/'`         | Base URI for tarballs.                           |
| `checksum_base_uri`     | String           | `'http://archive.apache.org/dist/tomcat/'`         | Base URI for checksum files.                     |
| `verify_checksum`       | true, false      | `true`                                             | Verify the tarball checksum.                     |
| `dir_mode`              | String           | `'0750'`                                           | Install directory mode.                          |
| `exclude_docs`          | true, false      | `true`                                             | Exclude `webapps/docs`.                          |
| `exclude_examples`      | true, false      | `true`                                             | Exclude `webapps/examples` and `webapps/ROOT`.   |
| `exclude_manager`       | true, false      | `false`                                            | Exclude `webapps/manager`.                       |
| `exclude_hostmanager`   | true, false      | `false`                                            | Exclude `webapps/host-manager`.                  |
| `tarball_uri`           | String           | generated from `tarball_base_uri` and `version`    | Complete tarball URI.                            |
| `checksum_uri`          | String           | generated from `checksum_base_uri` and `version`   | Complete checksum URI.                           |
| `tarball_path`          | String           | Chef file cache path                               | Local tarball cache path.                        |
| `tarball_validate_ssl`  | true, false      | `true`                                             | Validate HTTPS certificates for tarball fetches. |
| `tomcat_user`           | String           | `tomcat_INSTANCE`                                  | System user that owns the installation.          |
| `tomcat_group`          | String           | `tomcat_INSTANCE`                                  | System group that owns the installation.         |
| `tomcat_user_shell`     | String           | `'/bin/false'`                                     | Shell for created users.                         |
| `create_user`           | true, false      | `true`                                             | Create `tomcat_user`.                            |
| `create_group`          | true, false      | `true`                                             | Create `tomcat_group`.                           |
| `create_symlink`        | true, false      | `true`                                             | Create a stable symlink to `install_path`.       |
| `symlink_path`          | String           | `/opt/tomcat_INSTANCE`                             | Symlink path.                                    |

## Examples

### Basic Install

```ruby
tomcat_install 'default' do
  version '9.0.117'
end
```

### Local Tarball

```ruby
tomcat_install 'app' do
  version '9.0.117'
  verify_checksum false
  tarball_uri 'file:///tmp/apache-tomcat-9.0.117.tar.gz'
end
```
