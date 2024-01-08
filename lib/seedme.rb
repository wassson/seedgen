# frozen_string_literal: true

include ActiveRecord

module SeedMe
  def self.models
    if ApplicationRecord.descendants
      ApplicationRecord.descendants.each do |model|
        pp model.column_names
      end
    end
  end

  # helper method for viewing instance variables on
  # Descendant
  def self.vars
    ApplicationRecord.descendants.first.instance_variables
  end

  def self.exec(var)
    ApplicationRecord.descendants.first.instance_eval(var)
  end

  # NOTES
  # - ApplicationRecord.descendants[0].columns_hash => email.sql_type_metadata.type = :string
  # - ModelRelationshipMap
end

