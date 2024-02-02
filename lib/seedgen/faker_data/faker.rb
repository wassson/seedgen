require 'faker'

module SeedGen
  module FakerData
    class InvalidAttributeType < StandardError; end

    def self.generate(model, column)
      @model = model 
      @column = column

      case @column[:type].to_s
      when "binary"
        Faker::Number.binary
      when "boolean"
        Faker::Boolean.boolean
      when "date"
        Faker::Date.random
      when "datetime"
        Faker::Date.random
      when "decimal"
        Faker::Number.decimal
      when "float"
        # TODO
        3.03
      when "integer"
        if enum?
          range = @model.defined_enums[@column.name].length - 1
          return Faker::Number.between(from: 0, to: range)
        end
        Faker::Number.number(digits: 4)
      when "bigint"
        Faker::Number.number(digits: 10)
      when "string"
        Faker::Lorem.characters(number: rand(3..30))
      when "text"
        Faker::Company.bs
      when "time"
        Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
      else
        raise InvalidAttributeType
      end
    end

    private 

    def self.enum?
      @model.defined_enums.key?(@column)
    end
  end
end
