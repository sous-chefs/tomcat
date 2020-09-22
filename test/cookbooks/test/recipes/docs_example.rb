# make sure we have java installed
include_recipe 'java'

# Install Tomcat 7.0.103 to a custom path and install the example content / docs
tomcat_install 'docs' do
  version '7.0.103'
  exclude_examples false
  exclude_docs false
  install_path '/opt/special/tomcat_docs_7_0_103/'
end

# start the tomcat docs install
tomcat_service 'docs' do
  action [:start, :enable]
  install_path '/opt/special/tomcat_docs_7_0_103/'
end
