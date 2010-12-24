require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rdbi-arel"
  gem.homepage = "http://github.com/erikh/rdbi-arel"
  gem.license = "MIT"
  gem.summary = %Q{ARel Layer for RDBI}
  gem.description = %Q{Control RDBI with the SQL generation library ARel!}
  gem.email = "erik@hollensbe.org"
  gem.authors = ["Erik Hollensbe"]
  gem.add_dependency 'arel', '~> 2.0'
  gem.add_dependency 'rdbi', '>= 0.9.1'

  gem.add_development_dependency 'rdbi-dbrc'
  gem.add_development_dependency 'jeweler'
  gem.add_development_dependency 'rdbi-driver-postgresql'
  gem.add_development_dependency 'rdbi-driver-mysql'
  gem.add_development_dependency 'rdbi-driver-sqlite3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rdbi-arel #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
