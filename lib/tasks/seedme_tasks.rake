require "seedme"

namespace :seedme do
  desc "Seed database"
  task :seed do
    if ENV["SEED"] == "1"
      # SeedMe.models
      SeedMe.run
    end
  end

  Rake.application["db:schema:load"].enhance do
    Rake::Task["seedme:seed"].invoke
  end
end