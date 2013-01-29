require 'listable/view_manager'
require 'listable/connection_adapters'
require 'listable/querying'
require 'listable/railtie' if defined?(Rails)

module Listable
  module ClassMethods
    def listable_through(listable_view_name, scope_name)
      has_one listable_view_name.to_s.singularize, as: :listable

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
  
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end

class ActiveRecord::Base
  include Listable
  include Listable::Querying
end

class ActiveRecord::ConnectionAdapters::AbstractAdapter
  include Listable::ConnectionAdapters::SchemaStatements
end


