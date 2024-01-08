# SeedMe

SeedMe is a ruby gem that generates a seed file based on your schema and rails models.

## Getting Started

Rails allows us to pass environment variables into tasks. To run, pass `SEED=1` before
the schema load command:
```SEED=1 bundle exec rails db:schema:load```