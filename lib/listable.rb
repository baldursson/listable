require 'active_support/concern'

require 'listable/view_manager'
require 'listable/connection_adapters'
require 'listable/querying'
require 'listable/railtie' if defined?(Rails)

module Listable
  extend ActiveSupport::Concern

  module ClassMethods
    def listable_through(listable_view_name, scope_name)
      has_one listable_view_name.to_s.singularize.to_sym, as: :listable

      ViewManager.add_listable listable_view_name, self.name, scope_name
    end

    def acts_as_listable_view
      self.table_name = ViewManager.prefixed_view_name(self.name)
      belongs_to :listable, polymorphic: true
      include ViewMethods
    end
  end

  module ViewMethods
    def hash
      listable_id.hash + listable_type.hash
    end

    def eql?(result)
      listable_type == result.listable_type and
      listable_id == result.listable_id
    end

    def readonly?
      true
    end
  end
end

ActiveRecord::Base.send :include, Listable
ActiveRecord::Base.send :include, Listable::Querying

ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Listable::ConnectionAdapters::SchemaStatements

if defined?(Rails)
  # Extending connection adapters when lazily loaded by Rails
  require 'listable/railtie'
else
  require 'active_record/connection_adapters/sqlite_adapter'
  require 'active_record/connection_adapters/postgresql_adapter'
  require 'active_record/connection_adapters/mysql2_adapter'

  # Extending connection adapters
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, Listable::ConnectionAdapters::PostgreSQLExtensions)
  ActiveRecord::ConnectionAdapters::SQLiteAdapter.send(:include, Listable::ConnectionAdapters::SQLiteExtensions)
  ActiveRecord::ConnectionAdapters::Mysql2Adapter.send(:include, Listable::ConnectionAdapters::MySQLExtensions)
end
      