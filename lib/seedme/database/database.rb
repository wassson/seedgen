module SeedMe
  module Database 
    def self.adapter
      @adapter ||= ActiveRecord::Base.connection.adapter_name
    end

    def self.models
      ApplicationRecord.descendants
    end

    module MySQL; end
    module PostgreSQL; end
    module SQLite; end
  end
end