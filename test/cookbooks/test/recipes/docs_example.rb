# make sure we have java installed
include_recipe 'java'

# Install Tomcat 7.0.44 to a custom path and install the example content / docs
tomcat_install 'docs' do
  version '7.0.42'
  exclude_examples false
  exclude_docs false
  install_path '/opt/special/tomcat_docs_7_0_42/'
end

# start the tomcat docs install as a sys-v init service (because we hate ourselves)
tomcat_service_sysvinit 'docs' do
  action [:start, :enable]
  install_path '/opt/special/tomcat_docs_7_0_42/'
end
