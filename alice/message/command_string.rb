module Message

  class CommandString

    attr_accessor :content

    def initialize(content)
      self.content = content
    end

    def components
      @components ||= sanitized_content
    end

    def raw_command
      self.content.gsub(/^.?#{verb} /, "")
    end

    def subject
      return (components[0..(predicate_position - 1)] - [verb]).join(' ').gsub(/[\.\,\?\'\!]+$/, '').gsub("++", "")
    end

    def fragment
      (components - [verb]).join(' ')
    end

    def verb
      components[0].to_s.gsub(/^!/, '')
    end

    private

    def sanitized_content
      sanitized = self.content.split(' ').reject(&:blank?).reject{|c| c.downcase.include? ENV['BOT_SHORT_NAME'].downcase}
      sanitized.map{ |c| c.gsub(/\'s/, ' for').gsub(/^\!/,'').gsub(/\+/, '').gsub(/[\?\!\.\,]$/, '') }
    end

  end
end
