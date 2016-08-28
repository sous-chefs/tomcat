include_recipe 'java'

tomcat_install 'custom_path' do
  tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz'
  base_install_path '/opt/custom'
end
