module Alice

  class DirectCommand

    include Mongoid::Document

    field :verb
    field :handler_class
    field :handler_method
    field :response_kind, default: :message

    index({ verb: 1 }, { unique: true })

    validates_uniqueness_of :verb
    validates_presence_of :verb

    attr_accessor :raw_command

    def self.process(command_string)
      return unless command_string.is_direct_command?
      where(verb: message.verb).first
    end

    def invoke!
      klass.new(method: self.handler_method, raw_command: self.raw_command).process
    end

    private

    def klass
      eval(self.handler_class)
    end

  end

end
