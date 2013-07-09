require 'chefspec'
require 'berkshelf'
require 'tmpdir'
require 'fileutils'

TOPDIR = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$: << File.expand_path(File.dirname(__FILE__))

berks = Berkshelf::Berksfile.from_file(File.join(TOPDIR, "Berksfile"))
tmpdirname = Dir.mktmpdir("chefspec-berks")
berks.install(path: tmpdirname)
COOKBOOK_PATH = tmpdirname

RSpec.configure do |c|
  #c.filter_run :focus => true
  #c.run_all_when_everything_filtered = true
  c.after(:suite) do
    FileUtils.rm_rf(tmpdirname)
  end
end
