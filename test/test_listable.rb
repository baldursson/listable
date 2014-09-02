require 'helper'

class TestListable < Test::Unit::TestCase

      def setup
      Listable::ViewManager.create_views
    end

  def topical_items_count
    TopicalItems.count(:all)
  end

  def listable_items_count
    Page.listables.count(:all) + Employee.listables.count(:all) + NewsArticle.listables.count(:all)
  end

  context "a listable view model" do


    should "have as many rows as the models it lists" do
      assert_equal listable_items_count, topical_items_count
    end

    should "raise a read only exception when trying to write to" do
      assert_raise(ActiveRecord::ReadOnlyRecord) do
        TopicalItems.first.update_attribute(:title, 'New title')
      end
    end
  end

  context "the query method concat_select" do
    should "select arguments as a concatenated string" do
      concatenated_name = Employee.concat_select([:first_name, ' ', :last_name], :full_name).first.full_name
      assert_equal 'Johannes Baldursson', concatenated_name
    end
  end

  context "the query method select_as" do
    should "select fields as new names" do
      renamed_selection = Employee.select_as(first_name: 'fname', last_name: 'lname').first
      normal_selection = Employee.select([:first_name, :last_name]).first
      renamed_values = [renamed_selection.fname, renamed_selection.lname]
      normal_values = [normal_selection.first_name, normal_selection.last_name]

      assert_equal normal_values, renamed_values
    end
  end

end
