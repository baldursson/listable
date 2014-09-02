require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'test/unit'
require 'shoulda'
require 'active_record'
require 'active_support'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'listable'

class Test::Unit::TestCase
end

adapter = ENV["DB"] || "sqlite"
config = YAML::load_file(File.dirname(__FILE__) + "/database.yml")[adapter]

if ['postgres', 'mysql'].include? adapter
  ActiveRecord::Base.establish_connection(config.merge('database' => nil))
  ActiveRecord::Base.connection.create_database config['database']
  ActiveRecord::Base.establish_connection(config)
end

ActiveRecord::Base.establish_connection(config)

Test::Unit.at_exit do
  if ['postgres', 'mysql'].include? adapter
    ActiveRecord::Base.establish_connection(config.merge('database' => nil))
    ActiveRecord::Base.connection.drop_database config['database']
  end
end

load File.dirname(__FILE__) + "/schema.rb"
load File.dirname(__FILE__) + "/models.rb"
