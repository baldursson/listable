namespace :listable do
  desc "(Re)creates all listable views"
  task :migrate => :environment do
    puts "Creating Listable views..."
    Rails.application.eager_load!
    Listable::ViewManager.create_views
  end
end

# Rebuild views after db:migrate
Rake::Task['db:migrate'].enhance do
  Rake::Task['listable:migrate'].invoke
end