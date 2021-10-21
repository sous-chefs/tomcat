# make sure we get the correct version of java installed
default['test']['jdk_version'] = '11'

# pin to 9 for some platforms as packages for 11 are unavailable
# either are suitable for testing purposes
if node.platform?('debian') && node['platform_version'].to_i <= 9
  default['test']['jdk_version'] = '8'
elsif node.platform?('amazon')
  default['test']['jdk_version'] = '9'
end
