# make sure we have java installed
include_recipe 'java'

# Install Tomcat 8.0.32 to a custom path and install the example content / docs
tomcat_install 'docs' do
  version '8.0.32'
  exclude_examples false
  exclude_docs false
  install_path '/opt/special/tomcat_docs_8_0_32/'
end

# start the tomcat docs install
tomcat_service 'docs' do
  action [:start, :enable]
  install_path '/opt/special/tomcat_docs_8_0_32/'
end
