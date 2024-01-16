require "faker"
require "seedme/database/database"
require "seedme/database/model_map"
require "seedme/railtie"
require "seedme/seed_file"
require "seedme/version"

module SeedMe
  SKIP_ATTRS = %w[ id created_at updated_at ]

  def self.run
    @models = Database.models || []
    @seeded_models = []

    @models.each do |model|
      seed(model)
      @seeded_models << model
    end

    puts database_seeded?
  end

  def self.seed(model)
    parents = parents(model)
    if parents.empty?
      create_record(model)
    else
      parents.each do |parent|
        seed(parent)
      end
    end
  end

  # returns parents that have not been persisted
  # TODO: refactor with filter
  # Ignore this awful code 🤮
  def self.parents(model)
    parents = []
    model.reflect_on_all_associations(:belongs_to) do |assoc|
      parents << assoc.name.to_s.capitalize
    end
    nonpersisted_parents = []

    parents.each do |parent|
      next if parent.active_record.count > 0
      nonpersisted_parents << parent.active_record
    end
    nonpersisted_parents
  end

  def self.create_record(model)
    puts "===================="
    puts "Creating: #{model}"
    attributes = attrs(model)
    parents = []
    model.reflect_on_all_associations(:belongs_to).each do |assoc|
      parents << assoc.name.to_s
    end

    unless parents.empty?
      parents.each do |parent|
        attributes.merge!({ parent.to_sym => Object.const_get(parent.capitalize).first })
      end
    end

    model.create!(attributes)
  end

  def self.attrs(model)
    data = {}

    columns = model.content_columns
    columns.each do |column|
      unless SKIP_ATTRS.include?(column.name)
        data[column.name.to_sym] = faker(model, column)
      end
    end

    data
  end

  class InvalidAttributeType < StandardError; end
  def self.faker(model, column)
    binding.b
    case column.sql_type_metadata.type
    when :binary
      Faker::Number.binary
    when :boolean
      # TODO
      true
    when :date
      # TODO
      Faker::Date.random
    when :datetime
      Faker::Date.random
    when :decimal
      Faker::Number.decimal
    when :float
      3.03
    when :integer
      # TODO
      if enum?(model, column.name)
        range = model.defined_enums[column.name].length - 1
        return Faker::Number.between(from: 0, to: range)
      end
      Faker::Number.number(digits: 4)
    when :bigint
      Faker::Number.number(digits: 10)
    when :string
      Faker::Alphanumeric.alpha(number: 7)
    when :text
      Faker::Company.bs
    when :time
      # TODO
      Faker::Date.time
    when :timestamp
      # TODO
      Faker::Date.time
    else
      raise InvalidAttributeType
    end
  end

  def self.enum?(model, column)
    model.defined_enums.key?(column)
  end

  # TODO: validate that all records have been created
  def self.database_seeded?
    @models == @seeded_models
  end
end
