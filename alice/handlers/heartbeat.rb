module Handlers
  class Heartbeat

    include PoroPlus
    include Behavior::HandlesCommands

    FREQUENCY = 4
    INACTIVITY_THRESHOLD = 5.minutes

    ACTIONS = [:summon_actor, :dismiss_actor, :steal, :actor_speaks, :suggest_topic]

    def random_act
      return unless channel_is_idle?
      return unless Util::Randomizer.one_chance_in(FREQUENCY)
      action = ACTIONS.sample
      self.send(action)
    end

    private

    def actor_speaks
      return unless actor = ::Place.current.actors.sample
      "#{actor.proper_name} says, \"#{actor.speak}\"."
    end

    def dismiss_actor
      return unless ::Place.current.actors.to_a.any?
      actor = ::Place.current.actors.first
      actor.in_play = false
      actor.place_id = nil
      actor.save
      "#{actor.proper_name} has left the room."
    end

    def steal
      return unless target = ::User.active_and_online.to_a.sample
      return unless item = target.items.sample
      User.bot.steal(item, :message)
    end

    def suggest_topic
      topic = ::Context.with_keywords.sample
      topic.current!
      "Let's talk about #{topic.topic} now."
    end

    def summon_actor
      return if ::Place.current.actors.any?
      actor = ::Actor.sample
      actor.put_in_play
      ::Place.current.actors << actor
      "#{actor.proper_name} has wandered into the room."
    end

    def last_active_user
      @last_active_user ||= User.active.sort_by(&:last_active).last
    end

    def channel_is_idle?
      return unless last_active_user
      last_active_user.last_active < (Time.now - INACTIVITY_THRESHOLD)
    end

  end

end
