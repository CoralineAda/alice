module IsA
  class Characteristic

    include Neo4j::ActiveNode
    # belongs_to :category, optional: true
    # has_many :categories
    # has_and_belongs_to_many :characteristics
    property :name

    has_many :out, :categories, type: :describes

    before_create :singularize_word

    def singularize_word
      self.name = self.name.singularize
    end

  end
end
