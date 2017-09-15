module IsA
  class Category

    include Neo4j::ActiveNode

    property :name, type: String

    has_many :out, :parents, type: :parent_of, model_class: "::IsA::Category"
    has_many :in, :children, type: :child_of, model_class: "::IsA::Category"
    has_many :in, :characteristics, type: :described_by, model_class: "IsA::Characteristic"

    validates_uniqueness_of :name

    before_create :singularize_word

    def singularize_word
      self.name = self.name.singularize
    end

    def is?(thing=self, classification)
      return false if thing.parents.empty?
      return true if thing.parents.include? classification
      thing.parents.uniq.map{ |parent| is?(parent, classification)}.select{ |response| response }.any?
    end

    def has_a?(classification=self, thing)
      return false unless self.children.any?
      return true if self.children.include?(thing)
      self.children.detect{|c| c.has_a?(c, thing)}
    end

    def any_child_has?(classification=self, characteristic)
      return false unless self.children.any?
      self.children.detect{|c| c.has?(characteristic) || c.any_child_has?(c, characteristic)}
    end

    def any_parent_has?(classification=self, characteristic)
      return false unless self.parents.any?
      self.parents.select{|parent| parent.has?(characteristic)}.any?
    end

    def is!(category)
      return if self.parents.include? category
      parents << category
      category.children << self
    end

    def connected?
      self.parents.any? || self.children.any?
    end

    def has?(characteristic)
      self.characteristics.include? characteristic
    end

    def has!(characteristic)
      return if has?(characteristic)
      self.characteristics << characteristic
    end

    def is_sibling?(category)
      !!shared_parent(category)
    end

    def plural_name
      self.name.pluralize
    end

    def shared_parent(category)
      (category.parents.to_a & self.parents.to_a).first
    end

  end
end
