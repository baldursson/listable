module Listable
  module ClassMethods

    def listable_through(listable_view, attributes)
      @listable_views ||= {}
      @listable_views[listable_view] = attributes

      has_one listable_view, as: :listable
    end

    def acts_as_listable_view
      belongs_to :listable, polymorphic: true
      include View
    end

  end

  module View

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
    receiver.extend         ClassMethods
  end
end

class ActiveRecord::Base
  include Listable
end