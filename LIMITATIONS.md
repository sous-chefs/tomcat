# Limitations

## Package Availability

This cookbook installs Apache Tomcat from upstream Apache tarball archives, not from operating
system packages. Platform support is therefore limited by current Linux lifecycle support, Java
availability, and the ability to run systemd.

Apache Tomcat currently supports the 9.0.x, 10.1.x, and 11.0.x release lines. Tomcat 9.0.x
requires Java 8 or later, Tomcat 10.1.x requires Java 11 or later, and Tomcat 11.0.x requires Java
17 or later. The test cookbook installs Java 17 by default so all currently supported Tomcat lines
can run.

### APT (Debian/Ubuntu)

No APT repository is used for Tomcat. Tested platforms use upstream tarballs:

* Debian 12
* Debian 13
* Ubuntu 22.04
* Ubuntu 24.04

### DNF/YUM (RHEL family, Fedora, Amazon Linux)

No DNF/YUM repository is used for Tomcat. Tested platforms use upstream tarballs:

* AlmaLinux 8, 9, 10
* Amazon Linux 2023
* CentOS Stream 9, 10
* Fedora latest
* Oracle Linux 8, 9, 10
* Rocky Linux 8, 9, 10

### Zypper (SUSE)

No Zypper repository is used for Tomcat. Tested platforms use upstream tarballs:

* openSUSE Leap 16

The `dokken/opensuse-leap-16` image is not published, so openSUSE Leap 16 remains in metadata and
non-Dokken Kitchen definitions but is excluded from Dokken CI until an image is available.

## Architecture Limitations

Apache publishes Tomcat tarballs as architecture-independent Java archives. This cookbook does not
compile Tomcat and does not select architecture-specific Tomcat packages.

## Source/Compiled Installation

This cookbook does not build Tomcat from source. It installs the binary tarball for the requested
Tomcat version and validates the upstream checksum by default.

## Known Issues

* Service management is systemd-only. Upstart and sysvinit platforms are not supported.
* Ubuntu 20.04, Debian 11, CentOS 7/8, openSUSE Leap 15, Scientific Linux, SUSE Linux Enterprise, and zLinux support
  were removed from the active test matrix because they are either end-of-life, untested by the
  current Dokken strategy, or not covered by current cookbook verification.

## References

* Apache Tomcat version and Java compatibility: <https://tomcat.apache.org/whichversion.html>
* Apache Tomcat 9 downloads and checksums: <https://tomcat.apache.org/download-90>
* Apache Tomcat migration guidance: <https://tomcat.apache.org/migration.html>
* OS lifecycle data: <https://endoflife.date/>
