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

    def self.included(receiver)
      receiver.extend ClassMethods
    end
  end
end
