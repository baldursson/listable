# encoding: utf-8

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
  gem.name = "listable"
  gem.homepage = "http://github.com/baldursson/listable"
  gem.license = "MIT"
  gem.summary = %Q{ActiveRecord extension that makes it easy to list and query several models through a single view backed model.}
  gem.description = %Q{With listable you can consolidate fields from several models into one, backed up by a database view.
                       It is perfect for e.g. a front page where you may want to display the most recent additions to your site in a joint list.
                       By providing scopes for each model you wish to include in a view, Listable will automatically create the database view for you.}
  gem.email = "johannes.baldursson@gmail.com"
  gem.authors = ["Johannes Baldursson"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "listable #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
