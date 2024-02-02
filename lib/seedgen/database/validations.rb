module SeedGen
  module Database
    module Validations
      class InvalidValidator < StandardError; end
      NUMERICALITY_VALIDATIONS = [
        :greater_than,
        :greater_than_or_equal_to,
        :equal_to,
        :less_than,
        :less_than_or_equal_to,
        :only_integer,
        :odd,
        :even,
        :in,
        :other_than
      ]

      def self.run(validation, column)
        @validation = validation
        @klass = @validation.class.to_s
        @column = column

        handle_validation
      end

      private

      def self.handle_validation
        case @klass
        # when ActiveRecord::Validations::LengthValidator
        #   handle_length
        when ActiveRecord::Validations::NumericalityValidator
          binding.break
          handle_numericality
        when "ActiveRecord::Validations::PresenceValidator"
          return
        else
          binding.b
          raise InvalidValidator
        end
      end

      def self.handle_numericality
        options = @validation.options.keys
        options.each do |o|
          # TODO: I don't think we want to actually raise, but rather
          # return something like "FIX ME" to provide the user with an
          # obvious place to update the code.
          raise InvalidValidator unless NUMERICALITY_VALIDATIONS.include?(o)

          # TODO: Is there a difference between:
          # 1. Two separate calls to 'validates' vs.
          # 2. One call to 'validates' with multiple options?
        end
      end
    end
  end
end

