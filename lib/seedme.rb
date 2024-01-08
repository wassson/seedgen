# frozen_string_literal: true

require "active_record"
require "seedme/railtie"

# NOTES
# - ApplicationRecord.descendants.last.columns_hash
# - ModelRelationshipMap
module SeedMe
  def self.run
    pp Database.adapter
    Database.models
  end

  module Database
    def self.adapter
      @adapter ||= ActiveRecord::Base.connection.adapter_name
    end

    def self.models
      if ApplicationRecord.descendants
        ApplicationRecord.descendants.each do |model|
          pp model
        end
      end
    end

    def self.column_type(column)
      pp self.sql_metadata(column).type
    end

    private

    def self.sql_metadata(column)
      pp column.sql_type_metadata
    end
  end
end

