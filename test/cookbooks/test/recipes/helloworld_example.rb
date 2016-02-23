tomcat_install 'helloworld' do
  version '8.0.32'
  exclude_examples false
end

tomcat_service 'helloworld' do
  action :start
  env_vars [{ 'CATALINA_PID' => '/opt/tomcat_helloworld/bin/helloworld.pid' }]
end
