require "seedme/database/database"
require "seedme/database/model_map"
require "seedme/faker"
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
        data[column.name.to_sym] = FakerData.generate(model, column)
      end
    end

    data
  end

  # TODO: validate that all records have been created
  def self.database_seeded?
    @models == @seeded_models
  end
end
