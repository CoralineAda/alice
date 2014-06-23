module Alice

  module Behavior

    module Searchable

      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods

        def search_attr
          :name
        end

        # Use when there are multiple words to parse. May be deprecated.
        def from(string)
          return [] unless string.present?
          names = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\-\_\ ]/, '')).omnigrams
          names = names.map{|g| g.join ' '} << string
          names.uniq.reject!{|name| Alice::Parser::LanguageHelper::IDENTIFIERS.include?(name)}
          objects = names.map do |name|
            name = (name.split(/\W+/) - Alice::Parser::LanguageHelper::IDENTIFIERS).compact.join(' ')
            if name.present? && found = like(name)
              SearchResult.new(term: name, result: found)
            end
          end.compact
          objects = objects.select{|obj| obj.result.present?}.uniq || []
          objects.sort{|b,a| b.term.length <=> a.term.length}.map(&:result).last
        end

        # Use when you need to do a case-insensitive match
        def like(name)
          name = name.respond_to?(:join) && name.join(' ') || name
          unless match = where("#{search_attr}" => /^#{Regexp.escape(name)}$/i).first
            match = where("#{search_attr}" => /\b#{Regexp.escape(name)}\b/i).first
          end
          match
        end

      end

      class SearchResult
        include PoroPlus
        attr_accessor :term, :result
      end

    end

  end

end