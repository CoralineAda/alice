class CommandString

  include PoroPlus

  attr_accessor :content

  def self.process(command_string)
    command_string.execute!
  end

  def components
    @components ||= self.content.split(/\W+/).reject{|w| w.blank? }
  end

  def execute!
  end

  def has_predicate?
    predicate_position.present?
  end

  def is_direct_command?
     self.content[0] == "!"
  end

  def predicate
    components[(predicate_position + 1)..-1].join(' ')
  end

  def predicate_position
    components.index('to') || components.index('from')
  end

  def subject
    return components[1..-1].join(' ') unless has_predicate?
    return components[1..(predicate_position - 1)].join(' ')
  end

  def verb
    components[0]
  end

end
