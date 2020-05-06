# make sure we get the correct version of java installed
default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '11'
default['java']['set_etc_environment'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true

# pin to 8 for some platforms as packages for 11 are unavailable
# either are suitable for testing purposes
if node.platform?('amazon') ||
   (
     node.platform?('debian') && node['platform_version'].to_i <= 9
   )

  default['java']['jdk_version'] = '8'
end
