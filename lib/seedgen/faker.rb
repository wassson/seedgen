require 'faker'

module SeedGen
  class FakerData
    class InvalidAttributeType < StandardError; end

    def self.generate(model, column)
      new(model, column).generate
    end

    def initialize(model, column)
      @model = model 
      @column = column
    end

    def generate
      case @column.sql_type_metadata.type
      when :binary
        Faker::Number.binary
      when :boolean
        Faker::Bolean.boolean
      when :date
        Faker::Date.random
      when :datetime
        Faker::Date.random
      when :decimal
        Faker::Number.decimal
      when :float
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
        Faker::Alphanumeric.alpha(number: 7)
      when :text
        Faker::Company.bs
      when :time
        Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
      else
        raise InvalidAttributeType
      end
    end

    private 

    def enum?
      @model.defined_enums.key?(@column)
    end
  end
end
