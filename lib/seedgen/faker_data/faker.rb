require 'faker'

module SeedGen
  module FakerData
    class InvalidAttributeType < StandardError; end

    def self.generate(model, column)
      @model = model 
      @column = column

      self.parse_options
      if options?
        min = @options[:minimum]
        max = @options[:maximum]
      else
        case @column.sql_type_metadata.type
        when :binary
          Faker::Number.binary
        when :boolean
          Faker::Boolean.boolean
        when :date
          Faker::Date.random
        when :datetime
          Faker::Date.random
        when :decimal
          Faker::Number.decimal
        when :float
          # TODO
          3.03
        when :integer
          if enum?
            range = @model.defined_enums[@column.name].length - 1
            return Faker::Number.between(from: 0, to: range)
          end
          # Otherwise, find min/max
          Faker::Number.number(digits: 4)
        when :bigint
          Faker::Number.number(digits: 10)
        when :string
          if self.options?
            binding.b

            Faker::Lorem.characters(number: rand(min..max))
          else
            Faker::Lorem.characters(number: rand(3..30))
          end
        when :text
          Faker::Company.bs
        when :time
          Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
        else
          raise InvalidAttributeType
        end
      end

    end

    private 

    def self.enum?
      @model.defined_enums.key?(@column)
    end

    def self.options?
      !@options&.empty?  
    end

    def self.parse_options
      validators = @model.validators
      @options = validators.select { |val| val.attributes.include?(@column.name.to_sym) } || {}  
    end
  end
end
