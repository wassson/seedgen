module SeedMe
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "tasks/seedme_tasks.rake"
    end
  end
end
