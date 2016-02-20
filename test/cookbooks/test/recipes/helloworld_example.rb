tomcat_install 'helloworld' do
  version '8.0.32'
end

tomcat_service 'helloworld' do
  action :start
end
