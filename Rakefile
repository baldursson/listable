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
  gem.summary = %Q{Rails extension that makes it easy to list and query several models through a single view backed model.}
  gem.description = %Q{With listable you can consolidate fields from several models into one, backed up by a database view.
                       It is perfect for e.g. a front page where you may want to display the most recent additions to your site in a joint list.
                       By providing scopes for each model you wish to include in a view, Listable will automatically create the database view for you.
                       Using the provided helpers and query extensions, you will be good to go in no time.
                       }
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

# require 'simplecov/rcovtask'
# Rcov::RcovTask.new do |test|
#   test.libs << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
#   test.rcov_opts << '--exclude "gems/*"'
# end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "listable #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :listable do
  desc "Creating Listable database views..."
  task :migrate => :environment do
    Rails.application.eager_load!
    Listable::ViewManager.create_views
  end
end

