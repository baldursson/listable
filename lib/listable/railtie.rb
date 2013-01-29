#require 'rake'

module Listable
  class Railtie < Rails::Railtie
    initializer "listable" do
      # Rebuild views after db:migrate
      # Rake::Task['db:migrate'].enhance do
      #   Rake::Task['listable:migrate'].invoke
      # end

      ActiveSupport.on_load :active_record do
        ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, Listable::ConnectionAdapters::PostgreSQLExtensions)
        #ActiveRecord::ConnectionAdapters::SQLiteAdapter.send(:include, Listable::ConnectionAdapters::SQLiteExtensions)
        #ActiveRecord::ConnectionAdapters::MysqlAdapter.send(:include, Listable::ConnectionAdapters::MySQLExtensions)
        #ActiveRecord::ConnectionAdapters::Mysql2Adapter.send(:include, Listable::ConnectionAdapters::MySQLExtensions)
      end
    end

    rake_tasks do
      load 'tasks/listable.rake'
    end
  end
end