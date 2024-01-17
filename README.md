# SeedGen
Generate seed files based on your Rails models and schema.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "seedgen", "~> 0.0.4"
```

## Usage
SeedGen hooks into your models to build you a seed file. After installation, run: 

```bash
SEED=1 rails db:schema:load
```

The above command generates `db/seedgen.rb` with a scaffold of all of your models and a line for each that will create the record in your db. 
SeedGen attempts to create a model tree and will write to the file in the order of Root -> Child. This is so that when you run your seed file, 
you won't run into any issues with relationships. For example, you may have a `Post` model that `belongs_to: user`. If the seed file attempts to create
a `Post` before its associated `User` is created, it'll obviously raise an error and crash.

Note: You may notice SeedGen missing some of your models. If this is the case, it is because
your application needs to eager load its classes for SeedGen to see them. 
In `config/application.rb`, add the below block in your test env:

```ruby
config.after_initialize do
  Rails.application.eager_load!
end
```

and rerun `SEED=1 rails db:schema:load`.

## Running the seed file
At the moment, `seedgen` doesn't provide you with a rake task to run this seed file. So, for now, you'll have to either 1) copy 
the contents of `seedgen.rb` into your `seed.rb` file, or create your own rake task in `lib/tasks`. Note: this is a high priority
issue.

## Example output of seeds/seedgen.rb

Let's imagine you have a database with two tables: `posts` & `users`. SeedGen will create the following order-specific seed file.

```ruby
# TODO: Add any code that needs to run before data is created.

User.create!(first_name: 'temgcpr', last_name: 'cuqoghi', email: 'zrcpqhn', password: 'ophpnxy')

Post.create!(title: 'vurkcff', body: 'morph back-end initiatives', status: 2, user_id: 1)

# TODO: Add any code that needs to run after data is created.
```