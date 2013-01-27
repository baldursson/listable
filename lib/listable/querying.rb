module Listable
  module Querying

    module ClassMethods

      def concat_select(fields, as_name)
        fields.map! { |field| connection.quote(field) }
        select("#{connection.concat(fields)} AS #{as_name}")
      end

      def select_as(fields)
        selection = []
        fields.each do |field, as_name|
          selection << "#{connection.quote(field)} AS #{as_name}"
        end
        select(selection * ', ')
      end

    end

    module SchemaStatements

      def create_view(view_name, queries)
        create_sql = "CREATE VIEW #{view_name.to_s.pluralize} AS "
        queries.map!(&:to_sql) # Compile the arel queries to sql
        create_sql << queries * ' UNION ' # Combines the queries with union

        execute create_sql
      end

      def drop_view(view_name)
        execute "DROP VIEW #{view_name}"
      end

    end

    module ConcatenationMethods
      module PipeOperator
        def concat(args)
          args * " || "
        end
      end

      module PlusOperator
        def concat(args)
          args * " + "
        end
      end

      module Function
        def concat(args)
          "CONCAT(#{args * ', '})"
        end
      end
    end

    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end

class ActiveRecord::ConnectionAdapters::AbstractAdapter
  include Listable::Querying::SchemaStatements
end


class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
  include Listable::Querying::ConcatenationMethods::PipeOperator

  def views
    query(<<-SQL, 'SCHEMA').map { |row| row[0] }
      SELECT table_name
      FROM INFORMATION_SCHEMA.views
      WHERE table_schema = ANY (current_schemas(false))
    SQL
  end
end

class ActiveRecord::ConnectionAdapters::MysqlAdapter
  include Listable::Querying::ConcatenationMethods::Function
end

class ActiveRecord::ConnectionAdapters::Mysql2Adapter
  include Listable::Querying::ConcatenationMethods::Function
end

class ActiveRecord::ConnectionAdapters::SQLiteAdapter
  include Listable::Querying::ConcatenationMethods::PipeOperator

    def views
      query(<<-SQL, 'SCHEMA').map { |row| row[0] }
        SELECT name
        FROM sqlite_master
        WHERE type = 'view';
      SQL
    end
end