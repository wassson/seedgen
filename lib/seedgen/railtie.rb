module SeedGen
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "tasks/seedgen_tasks.rake"
    end
  end
end
