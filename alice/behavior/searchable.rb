module Alice

  module Behavior

    module Searchable

      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods

        def from(string)
          return [] unless string.present?
          names = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams.map{|g| g.join ' '}
          names.map{|name| like(name) }.flatten.compact || []
        end

        def like(name)
          where(name: /#{name}$/i)
        end
        
      end

    end

  end

end