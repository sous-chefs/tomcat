require 'spec_helper'

RSpec.describe TomcatCookbook::InstallHelpers do
  class DummyClass < Chef::Node
    include TomcatCookbook::InstallHelpers
  end

  subject { DummyClass.new }

  describe '#major_version' do
    context 'Version 8' do
      let(:version) { '8' }

      it 'returns the correct major version' do
        expect(subject.major_version(version)).to eq '8'
      end
    end

    context 'Version 11.0.8.10.1' do
      let(:version) { '11.0.8.10.1' }

      it 'returns the correct major version' do
        expect(subject.major_version(version)).to eq '11'
      end
    end
  end

  describe '#default_tomcat_install_path' do
    context 'helloworld 9.0.37' do
      let(:instance_name) { 'helloworld' }
      let(:version) { '9.0.37' }

      it 'returns the correct path' do
        expect(subject.default_tomcat_install_path(instance_name, version)).to eq '/opt/tomcat_helloworld_9_0_37/'
      end
    end
  end

  describe '#default_tomcat_symlink_path' do
    context 'helloworld' do
      let(:instance_name) { 'helloworld' }

      it 'returns the correct path' do
        expect(subject.default_tomcat_symlink_path(instance_name)).to eq '/opt/tomcat_helloworld'
      end
    end
  end

  describe '#default_tomcat_archive_uri' do
    context '9.0.37' do
      let(:base_uri) { 'http://archive.apache.org/dist/tomcat/' }
      let(:version) { '9.0.37' }
      let(:version_archive) { 'apache-tomcat-9.0.37.tar.gz' }

      it 'returns the correct uri' do
        expect(subject.default_tomcat_archive_uri(base_uri, version, version_archive)).to eq 'http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz'
      end
    end
  end

  describe '#default_tomcat_checksum_uri' do
    context '9.0.37' do
      let(:base_uri) { 'http://archive.apache.org/dist/tomcat/' }
      let(:version) { '9.0.37' }
      let(:version_archive) { 'apache-tomcat-9.0.37.tar.gz' }

      it 'returns the correct uri' do
        expect(subject.default_tomcat_checksum_uri(base_uri, version, version_archive)).to eq 'http://archive.apache.org/dist/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz.sha512'
      end
    end
  end

  describe '#version_checksum_algorithm' do
    context '6.0.53' do
      let(:version) { '6.0.53' }

      it 'returns the correct checksum algorithm' do
        expect(subject.version_checksum_algorithm(version)).to eq 'md5'
      end
    end

    context '9.0.9' do
      let(:version) { '9.0.9' }

      it 'returns the correct uri algorithm' do
        expect(subject.version_checksum_algorithm(version)).to eq 'md5'
      end
    end

    context '9.0.10' do
      let(:version) { '9.0.10' }

      it 'returns the correct uri' do
        expect(subject.version_checksum_algorithm(version)).to eq 'sha512'
      end
    end
  end

  describe '#tomcat_archive_name' do
    context '9.0.37' do
      let(:version) { '9.0.37' }

      it 'returns the correct archive name' do
        expect(subject.tomcat_archive_name(version)).to eq 'apache-tomcat-9.0.37.tar.gz'
      end
    end
  end

  # TODO: Add test for fetch_tomcat_checksum

  # TODO: Add test for validate_tomcat_checksum
end
