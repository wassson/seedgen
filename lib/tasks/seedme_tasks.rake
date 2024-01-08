namespace :seedme do
  desc "Seed database"
  task :seed do
    if ENV["SEED"] == "1"
      puts "DATABASE SEEDED"
    end

    if ENV["SEEDFILE"] == "1"
      puts "SEED FILE CREATED"
    end
  end

  Rake.application["db:schema:load"].enhance do
    Rake::Task["seedme:seed"].invoke
  end
end
