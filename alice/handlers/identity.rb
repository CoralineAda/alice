module Handlers

  class Identity

    include PoroPlus
    include Behavior::HandlesCommands

    def bio
      message.response = subject.bio
    end

    private

    def subject
      Alice::Util::Logger.info "*** Command subject is #{command.subject}"
      @actor ||= ::Actor.from(command.subject)
    end

  end

end
