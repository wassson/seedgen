require "seedgen/database/database"
require "seedgen/faker"
require "seedgen/railtie"
require "seedgen/seed_file"
require "seedgen/version"

module SeedGen
  SKIP_ATTRS = %w[ id created_at updated_at ]

  def self.run
    @models = Database.models || []
    @scaffold = {}
    @scaffolded_models = []

    build_scaffold
  end

  def self.build_scaffold
    @models.each do |model|
      scaffold_record(model)
    end
    
    write_scaffold_to_file
  end

  def self.write_scaffold_to_file
    Dir.mkdir("db/seeds") unless File.exist?("db/seeds")
    File.open("db/seeds/seedgen.rb", "w") do |file|
      file.write("# TODO: Add any code that needs to run before data is created.\n\n")

      @scaffold.each do |key, value|
        create_model = "#{key}.create!("
        attrs = []
        value.each do |attr, v|
          if v.is_a? String
            attrs << "#{attr}: '#{v}'"
          else
            attrs << "#{attr}: #{v}"
          end
        end

        create_model += "#{attrs.join(', ')})\n\n"
        file.write(create_model)
      end

      file.write("# TODO: Add any code that needs to run after data is created.\n\n")
    end
  end

  def self.scaffold_record(model)
    model_parents = parents(model)
    if model_parents.empty?
      write_to_scaffold(model)
    else
      model_parents.each do |parent|
        scaffold_record(parent)
      end
      write_to_scaffold(model)
    end
  end

  def self.parents(model)
    model_parents = model.reflect_on_all_associations(:belongs_to).map { 
      |assoc| Object.const_get(assoc.name.capitalize) 
    } 
    model_parents.select { |p| @scaffold[p] }
  end

  def self.write_to_scaffold(model)
    attributes = attrs(model)
    parents = []

    model.reflect_on_all_associations(:belongs_to).each do |assoc|
      parents << assoc.name.to_s
    end

    unless parents.empty?
      parents.each do |parent|
        attributes.merge!({ "#{parent}_id" => 1 })
      end
    end

    @scaffold[model] = attributes
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
end
