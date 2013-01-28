namespace :listable do
  desc "Creating Listable database views..."
  task :migrate => :environment do
    Rails.application.eager_load!
    Listable::ViewManager.create_views
  end
end