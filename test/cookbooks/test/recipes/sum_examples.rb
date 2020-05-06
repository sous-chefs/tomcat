# make sure we have java installed
include_recipe 'java'

# Install Tomcat 9.0.34 (and verify against sha512 sums since we're 9.0.34 or later)
tomcat_install 'docs_90' do
  version '9.0.34'
  exclude_examples false
  exclude_docs false
  verify_checksum true
  install_path '/opt/special/tomcat_docs_9_0_34/'
end

# Install Tomcat 8.5.23 (and verify against md5 sums since we're earlier than 8.5.24)
tomcat_install 'docs_85' do
  version '8.5.23'
  exclude_examples false
  exclude_docs false
  verify_checksum true
  install_path '/opt/special/tomcat_docs_8_5_23/'
end
