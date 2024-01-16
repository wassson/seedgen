require 'rails'

module SeedMe
  module Database 
    class ModelMap
      class Node
        attr_accessor :model, :parents, :children

        def initialize(model)
          @model = model
          @parents = []
          @children = []
        end

        def add_child(node)
          @children << node
          node.parents << self
        end

        def add_parent(node)
          @parents << node
          node.children << self
        end

        def root
          self.parents.empty? ? self : self.parents.map(&:root).first
        end
      end

      attr_reader :nodes, :models

      def initialize
        @models = Database.models
        @nodes = {}
        build_map
      end

      def root
        @nodes.values ? @nodes.values.first.root : self
      end

      private

      def build_map
        @models.each do |model|
          model_node = @nodes[model] ||= Node.new(model)

          parent_models = model.reflect_on_all_associations(:belongs_to).map(&:klass)
          parent_models.each do |parent_model|
            parent_node = @nodes[parent_model] ||= Node.new(parent_model)
            model_node.add_parent(parent_node)
          end

          child_models = model.reflect_on_all_associations(:has_many)
                              .reject { |a| a.options[:through] }.map(&:klass)
          child_models.each do |child_model|
            child_node = @nodes[child_model] ||= Node.new(child_model)
            model_node.add_child(child_node)
          end
        end
      end
    end
  end
end