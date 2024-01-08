# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name                       = 'seedme'
  s.version                    = '0.0.1'
  s.summary                    = 'Generate a seed file based on your schema.'
  s.description                = 'Generate a seed file based on your schema, and define pre and post run actions.'
  s.required_ruby_version      = '>= 3.1'
  s.authors                    = [ 'Austin Wasson' ]
  s.email                      = 'austinpwasson@gmail.com'
  s.files                      = Dir["{lib}/**/*"] + [ 'README.md' ]
  s.license                    = 'MIT'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'minitest'
end
