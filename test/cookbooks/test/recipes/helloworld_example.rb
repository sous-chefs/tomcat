tomcat_install 'helloworld' do
  version '8.0.30'
end

tomcat_service 'helloworld' do
  action :start
end
