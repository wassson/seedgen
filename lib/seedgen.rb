require "seedgen/database/database"
require "seedgen/database/validations"
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
            column[:validations].each do |validation|
              Database::Validations.run(validation, column)
            end
          else
            data = FakerData.generate(model, column)
            if column[:type] == :string
              attrs << "#{attr}: '#{data}'"
            else
              attrs << "#{attr}: #{data}"
            end
          end
        end

        create_model += "#{attrs.join(', ')})\n\n"
        file.write(create_model)
      end

      file.write("# TODO: Add any code that needs to run after data is created.\n\n")
    end
  end
end
