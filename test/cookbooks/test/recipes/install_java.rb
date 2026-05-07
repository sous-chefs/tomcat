java_package =
  case node['platform_family']
  when 'debian'
    'openjdk-17-jdk'
  when 'amazon', 'fedora', 'rhel', 'suse'
    'java-17-openjdk-devel'
  else
    raise "Unsupported platform family for Java install: #{node['platform_family']}"
  end

package java_package
