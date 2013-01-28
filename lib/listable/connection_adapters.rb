module Listable
  module ConnectionAdapters

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

    module PostgreSQLExtensions
      include ConcatenationMethods::PipeOperator

      def views
        query(<<-SQL, 'SCHEMA').map { |row| row[0] }
          SELECT table_name
          FROM INFORMATION_SCHEMA.views
          WHERE table_schema = ANY (current_schemas(false))
        SQL
      end
    end

    module SQLiteExtensions
      include ConcatenationMethods::PipeOperator

      def views
        query(<<-SQL, 'SCHEMA').map { |row| row[0] }
          SELECT name
          FROM sqlite_master
          WHERE type = 'view';
        SQL
      end
    end

    module MySQLExtensions
      include ConcatenationMethods::Function

      def views()
        sql = "SHOW FULL TABLES "
        sql << "IN #{quote_table_name(current_database)} "
        sql << "WHERE TABLE_TYPE LIKE 'VIEW'" if like

        execute_and_free(sql, 'SCHEMA') do |result|
          result.collect { |field| field.first }
        end
      end
    end

  end
end