namespace :listable do
  desc "(Re)creates all listable views"
  task :migrate => :environment do
    puts "Creating Listable views..."
    Rails.application.eager_load!
    Listable::ViewManager.create_views
  end

  task :rollback => :environment do
    puts "Dropping Listable views..."
    Listable::ViewManager.drop_views
  end 
end

# Rebuild views after db:migrate
Rake::Task['db:migrate'].enhance do
  Rake::Task['listable:migrate'].invoke
end

# Drop views before a rollback to prevent errors due to column dependency
Rake::Task['db:rollback'].enhance ['listable:rollback']