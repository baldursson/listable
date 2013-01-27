module Listable
  module ClassMethods

    def listable_through(listable_view_name, scope_name)
      has_one listable_view_name.to_s.singularize, as: :listable

      ViewManager.add_listable listable_view_name, self.name, scope_name
    end

    def acts_as_listable_view
      table_name = ViewManager.prefixed_view_name(self.name)
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
  
  def self.included(receiver)
    receiver.extend ClassMethods
  end

  class ViewManager
    cattr_reader :listables

    class << self

      def prefixed_view_name(name)
        prefix << name
      end

      def prefix
        'lstble_'  
      end

      def add_listable(view_name, model_name, model_scope_name)
        @@listables ||= {}
        @@listables[view_name] ||= {}
        @@listables[view_name][model_name] = model_scope_name
      end

      def listable_view?(name)
        name.start_with? prefix
      end

      def create_views
        ActiveRecord::Base.transaction do
          drop_views # First drop all listable views to get a fresh start
          listables.each do |view_name, query_info|
            queries = []
            view_name = prefixed_view_name(view_name.to_s) # Appending a prefix to views
            query_info.each do |model_name, scope|
              model_class = Kernel.const_get(model_name)
              query = model_class.select_as(id: :listable_id) # Always begin selection with the original model ID
              query = query.send(scope) # Appends selection from scope
              query = query.select([:created_at, :updated_at]) # Include Rails' timestamps in view
              query = query.select("CAST ('#{model_name}' AS varchar) AS listable_type") # Finish with the original model name, needed for the polymorphic relation

              queries << query
            end
            ActiveRecord::Base.connection.create_view view_name, queries
          end
        end
      end

      def drop_views
        ActiveRecord::Base.connection.views.each do |name|
          ActiveRecord::Base.connection.drop_view(name) if listable_view? name
        end
      end
    end
  end
end

class ActiveRecord::Base
  include Listable
  include Listable::Querying
end

require 'listable/querying'
