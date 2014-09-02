module Listable
  class Railtie < Rails::Railtie
    initializer "listable" do
      ActiveSupport.on_load :active_record do
        # Extending connection adapters
        if ActiveRecord::ConnectionAdapters.const_defined?(:PostgreSQLAdapter)
          ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, Listable::ConnectionAdapters::PostgreSQLExtensions)
        end

        if ActiveRecord::ConnectionAdapters.const_defined?(:SQLiteAdapter)
          ActiveRecord::ConnectionAdapters::SQLiteAdapter.send(:include, Listable::ConnectionAdapters::SQLiteExtensions)
        end

        if ActiveRecord::ConnectionAdapters.const_defined?(:SQLite3Adapter)
          ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(:include, Listable::ConnectionAdapters::SQLiteExtensions)
        end

        if ActiveRecord::ConnectionAdapters.const_defined?(:Mysql2Adapter)
          ActiveRecord::ConnectionAdapters::Mysql2Adapter.send(:include, Listable::ConnectionAdapters::MySQLExtensions)
        end
      end
    end

    rake_tasks do
      load 'tasks/listable.rake'
    end
  end
end