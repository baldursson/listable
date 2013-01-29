module Listable
  module Querying

    module ClassMethods
      def concat_select(fields, as_name)
        fields.map! do |field|
          if field.is_a? Symbol
            connection.quote_column_name(field)
          else
            connection.quote(field)
          end
        end
        select("#{connection.concat(fields)} AS #{as_name}")
      end

      def select_as(fields)
        selection = []
        fields.each do |field, as_name|
          selection << "#{connection.quote_column_name(field)} AS #{as_name}"
        end
        select(selection * ', ')
      end
    end

    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end
