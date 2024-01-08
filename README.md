# SeedMe

SeedMe is a ruby gem that generates a seed file based on your schema and rails models.

## Getting Started

Rails allows us to pass environment variables into tasks. To run, pass `SEEDFILE=1` before
the schema load command to generate a seed file:
```bash
SEEDFILE=1 bundle exec rails db:schema:load
```

Or, pass `SEED=1` before the schema load command to have `SeedMe` attempt to automatically
seed your database without generating a seed file:
```
SEED=1 bundle exec rails db:schema:load
```