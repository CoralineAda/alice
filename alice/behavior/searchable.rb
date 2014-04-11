module Alice

  module Behavior

    module Searchable

      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods

        def from(string)
          return [] unless string.present?
          names = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\-\_\ ]/, '')).omnigrams.map{|g| g.join ' '} << string
          objects = names.map{|name| SearchResult.new(term: name, result: like(name).first) }
          objects = objects.select{|obj| obj.result.present?}.uniq || []
          objects.sort{|a,b| a.term.length <=> b.term.length}.map(&:result)
        end

        def like(name)
          where(name: /#{Regexp.escape(name)}$/i)
        end
        
      end

      class SearchResult
        include PoroPlus
        attr_accessor :term, :result
      end

    end

  end

end