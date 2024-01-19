require "seedgen/database/database"
require "seedgen/faker_data/faker"
require "seedgen/railtie"
require "seedgen/seed_file"
require "seedgen/validators"
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
      @model = model
      scaffold_model
    end
    
    write_scaffold_to_file
  end

  def self.scaffold_model
    @record = {}
    validations = @model.validators
    content_columns = @model.content_columns

    # scaffold parents
    # if @model.reflect_on_all_associations(:belongs_to).any?
    #   @model.reflect_on_all_associations(:belongs_to).each do |assoc|
    #     @record.merge!({ "#{assoc.name}_id" => 1 })
    #   end
    # end

    @record[@model] = []
    content_columns.each do |column|
      unless SKIP_ATTRS.include?(column.name)
        vals = validations.select { |v| v.attributes.include?(column.name.to_sym) }
        column_hash = { name: column.name.to_sym, type: column.type.to_sym }
        column_hash.merge!({ validations: vals })

        @record[@model] << column_hash
      end
    end

    @scaffold.merge! @record
    # binding.b if @model == Post
  end

  def self.write_scaffold_to_file
    Dir.mkdir("db/seeds") unless File.exist?("db/seeds")
    File.open("db/seeds/seedgen.rb", "w") do |file|
      file.write("# TODO: Add any code that needs to run before data is created.\n\n")

      @scaffold.each do |model, columns|
        create_model = "#{model}.create!("
        attrs = []
        columns.each  do |column|
          if column[:validations].any?
          else
            if column[:type] == :string
              attrs << "#{attr}: '#{v}'"
            else
              attrs << "#{attr}: #{v}"
            end
          end
        end

        create_model += "#{attrs.join(', ')})\n\n"
        file.write(create_model)
      end

      file.write("# TODO: Add any code that needs to run after data is created.\n\n")
    end
  end

  # def self.write_scaffold_to_file
  #   Dir.mkdir("db/seeds") unless File.exist?("db/seeds")
  #   File.open("db/seeds/seedgen.rb", "w") do |file|
  #     file.write("# TODO: Add any code that needs to run before data is created.\n\n")
  #
  #     @scaffold.each do |key, value|
  #       create_model = "#{key}.create!("
  #       attrs = []
  #       value.each  do |attr, v|
  #         if v.is_a? String
  #           attrs << "#{attr}: '#{v}'"
  #         else
  #           attrs << "#{attr}: #{v}"
  #         end
  #       end
  #
  #       create_model += "#{attrs.join(', ')})\n\n"
  #       file.write(create_model)
  #     end
  #
  #     file.write("# TODO: Add any code that needs to run after data is created.\n\n")
  #   end
  # end
  #
  # def self.scaffold_record(model)
  #   model_parents = parents(model)
  #   if model_parents.empty?
  #     write_to_scaffold(model)
  #   else
  #     model_parents.each do |parent|
  #       scaffold_record(parent)
  #     end
  #     write_to_scaffold(model)
  #   end
  # end
  #
  # def self.parents(model)
  #   model_parents = model.reflect_on_all_associations(:belongs_to).map {
  #     |assoc| Object.const_get(assoc.name.capitalize)
  #   }
  #   model_parents.select { |p| @scaffold[p] }
  # end
  #
  # def self.write_to_scaffold(model)
  #   attributes = attrs(model)
  #   parents = []
  #
  #   model.reflect_on_all_associations(:belongs_to).each do |assoc|
  #     parents << assoc.name.to_s
  #   end
  #
  #   unless parents.empty?
  #     parents.each do |parent|
  #       attributes.merge!({ "#{parent}_id" => 1 })
  #     end
  #   end
  #
  #   @scaffold[model] = attributes
  # end
  #
  # def self.attrs(model)
  #   columns = {}
  #   validators = self.validators(model)
  #   parents = self.parents(model)
  #
  #   # binding.b
  #
  #   content_columns = model.content_columns
  #   content_columns.each do |col|
  #     unless SKIP_ATTRS.include?(col.name)
  #       binding.b
  #     end
  #   end
  #   # columns.each do |column|
  #   #   unless SKIP_ATTRS.include?(column.name)
  #   #     data[column.name.to_sym] = FakerData.generate(model, column)
  #   #   end
  #   # end
  #
  #   columns
  # end
  #
  # def self.validators(model)
  #   vals = {}
  #   model.validators.each do |val|
  #     puts val
  #   end
  # end
end
