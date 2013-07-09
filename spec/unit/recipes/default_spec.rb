require 'spec_helper'

# Note: Due to a bug in the Java cookook that's been fixed but not
# yet merged at the time of this writing (COOK-3295) this spec 
# suite has no default, platformless test environment.

describe "tomcat::default" do
  %w{6 7}.each do |tomcat_base_version|

    context "CentOS 6.3, tomcat #{tomcat_base_version}" do
      let(:chef_run) do
        runner = ChefSpec::ChefRunner.new(
          platform: 'centos',
          version: '6.3',
          log_level: :error,
          cookbook_path: COOKBOOK_PATH
        ) do |node|
            node.set['tomcat']['base_version'] = tomcat_base_version
          end
        Chef::Config.force_logger true
        runner.converge('recipe[tomcat::default]')
      end

      it "Includes the java default recipe" do
        expect(chef_run).to include_recipe 'java'
      end

      it "installs the RHEL-family tomcat#{tomcat_base_version} packages" do
        expect(chef_run).to install_package "tomcat#{tomcat_base_version}"
        expect(chef_run).to install_package "tomcat#{tomcat_base_version}-admin-webapps"
      end

      it "creates the tomcat#{tomcat_base_version} endorsed directory" do
        expect(chef_run).to create_directory "/usr/share/tomcat#{tomcat_base_version}/lib/endorsed"
      end

      context "deploy_manager_apps set to false" do
        let(:chef_run) do
          runner = ChefSpec::ChefRunner.new(
            platform: 'centos',
            version: '6.3',
            log_level: :error,
            cookbook_path: COOKBOOK_PATH
          ) do |node|
              node.set['tomcat']['deploy_manager_apps'] = false
              node.set['tomcat']['base_version'] = tomcat_base_version
            end
          Chef::Config.force_logger true
          runner.converge('recipe[tomcat::default]')
        end

        it "deletes the manager directory" do
          expect(chef_run).to delete_directory "/var/lib/tomcat#{tomcat_base_version}/webapps/manager"
        end

        it "deletes the manager.xml file" do
          expect(chef_run).to delete_file "/etc/tomcat#{tomcat_base_version}/Catalina/localhost/manager.xml"
        end

        it "deletes the host-manager directory" do
          expect(chef_run).to delete_directory "/var/lib/tomcat#{tomcat_base_version}/webapps/host-manager"
        end

        it "deletes the host-manager.xml file" do
          expect(chef_run).to delete_file "/etc/tomcat#{tomcat_base_version}/Catalina/localhost/host-manager.xml"
        end
      end

      it "starts and enables the tomcat#{tomcat_base_version} service" do
        expect(chef_run).to start_service "tomcat#{tomcat_base_version}"
        expect(chef_run).to set_service_to_start_on_boot "tomcat#{tomcat_base_version}"
      end

      ##TODO: Verify that the passwords get set

      it "Creates the tomcat#{tomcat_base_version} sysconfig file" do
        expect(chef_run).to create_file "/etc/sysconfig/tomcat#{tomcat_base_version}"
        file = chef_run.template("/etc/sysconfig/tomcat#{tomcat_base_version}")
        expect(file).to be_owned_by('root', 'root')
      end

      it "Creates the tomcat#{tomcat_base_version} server.xml file" do
        expect(chef_run).to create_file "/etc/tomcat#{tomcat_base_version}/server.xml"
        file = chef_run.template("/etc/tomcat#{tomcat_base_version}/server.xml")
        expect(file).to be_owned_by('root', 'root')
      end

      it "Creates the tomcat#{tomcat_base_version} logging.properties file" do
        expect(chef_run).to create_file "/etc/tomcat#{tomcat_base_version}/logging.properties"
        file = chef_run.template("/etc/tomcat#{tomcat_base_version}/logging.properties")
        expect(file).to be_owned_by('root', 'root')
      end

      ## TODO: Write context that sets truststore file to a value

      ## TODO: Write context that sets ssl_cert_file to a value

    end

    context "Ubuntu 12.04, tomcat #{tomcat_base_version}" do
      let(:chef_run) do
        runner = ChefSpec::ChefRunner.new(
          platform: 'ubuntu',
          version: '12.04',
          log_level: :error,
          cookbook_path: COOKBOOK_PATH
        ) do |node|
            node.set['tomcat']['base_version'] = tomcat_base_version
          end
        Chef::Config.force_logger true
        runner.converge('recipe[tomcat::default]')
      end

      it "installs the Debian-family tomcat#{tomcat_base_version} packages" do
        expect(chef_run).to install_package "tomcat#{tomcat_base_version}"
        expect(chef_run).to install_package "tomcat#{tomcat_base_version}-admin"
      end

      it "Creates the tomcat#{tomcat_base_version} default file" do
        expect(chef_run).to create_file "/etc/default/tomcat#{tomcat_base_version}"
        file = chef_run.template("/etc/default/tomcat#{tomcat_base_version}")
        expect(file).to be_owned_by('root', 'root')
      end

    end

  end
end
