# Seedme
Generate seed files based on your schema.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "seedme", "~> 0.0.1"
```

## Usage
SeedMe hooks in to your models and their relationships to build you a seed file. After installation,
run: 

```bash
SEED=1 rails db:schema:load
```

The above command generates `db/seedme.rb` and seeds your database with the output of this new file based on your schema/models.

Note: You may notice SeedMe missing some of your models. If this is the case, it is because
your application needs to eager load its classes for SeedMe to see them. 
In `config/application.rb`, add:

```ruby
config.after_initialize do
  Rails.application.eager_load!
end
```

and rerun `SEED=1 rails db:schema:load`.