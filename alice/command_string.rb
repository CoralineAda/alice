module Alice

  class CommandString

    include PoroPlus

    attr_accessor :content, :sender

    def verb
      components[0]
    end

    def subject
      return components[1..-1].join(' ') unless has_predicate?
      return components[1..(predicate_position - 1)].join(' ')
    end

    def has_predicate?
      predicate_position.present?
    end

    def predicate
      components[(predicate_position + 1)..-1].join(' ')
    end

    def predicate_position
      components.index('to')
    end

    def components
      @components ||= self.content.split(/\W+/).reject{|w| w.blank? }
    end

  end

end
