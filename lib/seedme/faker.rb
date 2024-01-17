require 'faker'

module SeedMe
  module FakerData
    class InvalidAttributeType < StandardError; end

    def self.generate(model, column)
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
  end
end