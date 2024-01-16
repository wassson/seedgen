require_relative "lib/seedme/version"

Gem::Specification.new do |spec|
  spec.name        = "seedme"
  spec.version     = SeedMe::VERSION
  spec.authors     = ["Austin Wasson"]
  spec.email       = ["austinpwasson@gmail.com"]
  spec.homepage    = "https://github.com/wassson/seedme.git"
  spec.summary     = "Generate seed files from your schema."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wassson/seedme.git"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "faker"
  spec.add_dependency "rails", ">= 7.1.2"
end
