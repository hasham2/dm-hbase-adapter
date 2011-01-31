require 'rubygems'
require 'rake'

require 'lib/dm-hbase-adapter'

def with_gem(gemname, &blk)
  begin
    require gemname
    blk.call
  rescue LoadError => e
    puts "Failed to load gem #{gemname} because #{e}"
  end
end

with_gem 'spec/rake/spectask' do

  desc 'Run all specs'
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
    t.libs << 'lib'
    t.spec_files = FileList['spec/**_spec.rb']
  end

  desc 'Default: Run Specs'
  task :default => :spec

  desc 'Run all tests'
  task :test => :spec
end

