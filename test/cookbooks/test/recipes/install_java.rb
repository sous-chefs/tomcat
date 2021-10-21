# make sure we have java installed
openjdk_install do
  version node['test']['jdk_version']
  default true
end
