module Listable
  class Railtie < Rails::Railtie
    initializer "listable" do
      # Rebuild views after db:migrate
      Rake::Task['db:migrate'].enhance do
        Rake::Task['listable:migrate'].invoke
      end
    end

    rake_tasks do
      load 'lib/tasks/listable.rake'
    end
  end
end