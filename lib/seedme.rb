require "seedme/database/database"
require "seedme/database/model_map"
require "seedme/railtie"
require "seedme/seed_file"
require "seedme/version"

module SeedMe
  def self.run
    map = Database::ModelMap.new
    seed(map.root) if map.root
  end

  def self.seed(node)
    if node.parents.empty?
      # model = node.model
      # model.create
    end
  end
end
