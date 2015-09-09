require 'spec_helper'

describe package('tomcat') do
  it { should be_installed }
end

describe service('tomcat') do
  it { should be_enabled }
  it { should be_running }
end
