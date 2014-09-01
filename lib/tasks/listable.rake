require 'active_record'

namespace :listable do
  desc "(Re)creates all listable views"
  task :create => :environment do
    Rails.application.eager_load!

    ActiveRecord::Migration.say_with_time "Listable::ViewManager.create_views" do
      Listable::ViewManager.create_views
    end
  end

  task :drop => :environment do
    ActiveRecord::Migration.say_with_time "Listable::ViewManager.drop_view" do
      Listable::ViewManager.drop_views
    end
  end 
end

# Rebuild views after db:migrate
Rake::Task['db:migrate'].enhance do
  Rake::Task['listable:create'].invoke
end

# Rebuild views after db:setup
Rake::Task['db:setup'].prerequisites.unshift 'listable:drop'
Rake::Task['db:setup'].enhance do
  Rake::Task['listable:create'].invoke
end

# Drop views before a rollback to prevent errors due to column dependency
Rake::Task['db:drop'].enhance ['listable:drop']
Rake::Task['db:rollback'].enhance ['listable:drop']