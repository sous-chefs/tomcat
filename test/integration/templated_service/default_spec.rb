puts 'Sleeping to make sure the services are started'
sleep 10

script = <<~BASH
  systemctl show -p Description tomcat_template \
    || grep -i 'description' /etc/init/tomcat_template.conf \
                             /etc/init.d/tomcat_template
BASH

describe command(script) do
  its('stdout') { should match /My Apache Tomcat Application/ }
end
