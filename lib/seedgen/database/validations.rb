# frozen_string_literal: true

module SeedGen
  module Database
    module Validations
      class InvalidValidator < StandardError; end
      DUPLICATE_VALIDATION = "Duplicate validation found".freeze
      CONFLICTING_VALIDATION = "Conflicting validation found".freeze
      FIX_ATTRIBUTE = "FIX ME".freeze

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
      ].freeze

      def self.run(validation, column)
        @validation = validation
        @klass = @validation.first
        @column = column

        validate_column
      end

      private

      def self.validate_column
        case @klass
        # when ActiveRecord::Validations::LengthValidator
        #   handle_length
        when "ActiveRecord::Validations::NumericalityValidator"
          handle_numericality
          return
        when "ActiveRecord::Validations::PresenceValidator"
          return nil
        else
          # We don't want to throw, we want to prompt the user so
          # they know how to fix what SeedGen couldn't generate itself.
          # Ex: User.create(first_name: "FIX ME")
          return FIX_ATTRIBUTE
        end
      end

      # TODO: RESUME: iterate over validations to build attr
      def self.handle_numericality
        attr = nil
        options = @validation.last
        keys = options.keys
        keys.each do |opt|
          return FIX_ATTRIBUTE unless NUMERICALITY_VALIDATIONS.include?(opt)

          binding.break
          attr = FakerData.generate()
        end
      end
    end
  end
end

