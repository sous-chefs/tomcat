# frozen_string_literal: true

require 'spec_helper'

describe 'tomcat_service' do
  step_into :tomcat_service
  platform 'ubuntu', '24.04'

  context 'with action :create' do
    recipe do
      tomcat_service 'default' do
        action :create
      end
    end

    it do
      is_expected.to create_systemd_unit('tomcat_default.service').with(
        content: {
          Unit: {
            Description: 'default Apache Tomcat Application',
            After: 'syslog.target network.target',
          },
          Service: {
            Type: 'forking',
            Environment: [
              'CATALINA_BASE=/opt/tomcat_default',
              'CATALINA_PID=$CATALINA_BASE/bin/tomcat.pid',
            ],
            ExecStart: '/opt/tomcat_default/bin/catalina.sh start',
            ExecStop: '/opt/tomcat_default/bin/catalina.sh stop',
            SuccessExitStatus: '0 143',
            Restart: 'on-failure',
            RestartSec: 2,
            User: 'tomcat_default',
            Group: 'tomcat_default',
          },
          Install: {
            WantedBy: 'multi-user.target',
          },
        }
      )
    end
  end

  context 'with action :start' do
    recipe do
      tomcat_service 'default' do
        action :start
      end
    end

    it { is_expected.to create_systemd_unit('tomcat_default.service') }
    it { is_expected.to start_systemd_unit('tomcat_default.service') }
  end

  context 'with action :enable' do
    recipe do
      tomcat_service 'default' do
        action :enable
      end
    end

    it { is_expected.to create_systemd_unit('tomcat_default.service') }
    it { is_expected.to enable_systemd_unit('tomcat_default.service') }
  end

  context 'with action :delete' do
    recipe do
      tomcat_service 'default' do
        action :delete
      end
    end

    it { is_expected.to stop_systemd_unit('tomcat_default.service') }
    it { is_expected.to disable_systemd_unit('tomcat_default.service') }
    it { is_expected.to delete_systemd_unit('tomcat_default.service') }
  end

  context 'with custom service content' do
    recipe do
      tomcat_service 'custom' do
        unit_content <<~UNIT
          [Unit]
          Description=Custom Tomcat
        UNIT
      end
    end

    it { is_expected.to create_systemd_unit('tomcat_custom.service').with(content: "[Unit]\nDescription=Custom Tomcat\n") }
  end
end
