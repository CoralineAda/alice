module Behavior

  module Searchable

    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods

      def search_attr
        :name
      end

     # Use when there are multiple words to parse, e.g. pulling a name from a string.
      def from(string)
        return unless string.present?
        names = Grammar::NgramFactory.new(string).omnigrams
        names = names.map{|g| g.join ' '} << string
        names = names.uniq - Grammar::LanguageHelper::IDENTIFIERS
        objects = names.map do |name|
          name = (name.split(/\s+/) - Grammar::LanguageHelper::IDENTIFIERS).compact.join(' ')
          if name.present? && found = like(name) || found = where(name: name).first
            result = SearchResult.new(term: name, result: found)
          end
        end.compact
        objects = objects.select{|obj| obj.result.present?}.uniq || []
        objects.sort{|b,a| b.term.length <=> a.term.length}.map(&:result).last
      end

      # Use when you need to do a case-insensitive match
      def like(name)
        name = name.respond_to?(:join) && name.join(' ') || name
        like_all(name).first
      end

      def like_all(name)
        matches = []
        matches << where("#{search_attr}" => /^#{Regexp.escape(name)}/i).to_a
        matches << where("#{search_attr}" => /^#{Regexp.escape(name)}$/i).to_a
        matches << where("#{search_attr}" => /\W#{Regexp.escape(name)}\W/i).to_a
        return matches
      end

    end

    class SearchResult
      include PoroPlus
      attr_accessor :term, :result
    end

  end

end
