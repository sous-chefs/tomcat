openjdk_install "Install OpenJDK Java #{node['test']['jdk_version']}" do
  version node['test']['jdk_version']
  default true
end
