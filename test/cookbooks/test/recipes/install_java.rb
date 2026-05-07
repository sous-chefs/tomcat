java_package =
  case node['platform']
  when 'amazon'
    'java-17-amazon-corretto-devel'
  when 'debian'
    if node['platform_version'].to_i >= 13
      'openjdk-21-jdk'
    else
      'openjdk-17-jdk'
    end
  when 'ubuntu'
    'openjdk-17-jdk'
  when 'fedora'
    'java-latest-openjdk-devel'
  when 'almalinux', 'centos', 'centos_stream', 'oracle', 'rocky'
    if node['platform_version'].to_i >= 10
      'java-21-openjdk-devel'
    else
      'java-17-openjdk-devel'
    end
  when 'opensuseleap'
    'java-17-openjdk-devel'
  when 'redhat'
    'java-17-openjdk-devel'
  else
    raise "Unsupported platform for Java install: #{node['platform']}"
  end

package java_package
