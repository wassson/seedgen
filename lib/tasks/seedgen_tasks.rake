require "seedgen"

namespace :seedgen do
  desc "Seed database"
  task :seed do
    if ENV["SEED"] == "1"
      # SeedGen.models
      SeedGen.run
    end
  end

  Rake.application["db:schema:load"].enhance do
    Rake::Task["seedgen:seed"].invoke
  end
end