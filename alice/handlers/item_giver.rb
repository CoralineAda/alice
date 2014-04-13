module Alice

  module Handlers

    class ItemGiver

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        return unless giver = Alice::User.with_nick_like(sender)
        return unless grams = Alice::Parser::NgramFactory.filtered_grams_from(command)
        grams = grams.flatten.map{|g| g.gsub(/[^\w]/, '')}.map(&:downcase)
        candidates = Alice::Util::Mediator.user_list.map(&:nick).map(&:downcase) & grams
        return unless recipient = Alice::User.like(candidates.first)
        process_gift(giver, recipient, grams) || process_unknown
      end

      def self.process_gift(giver, recipient, grams)
        
        items = grams.map{|g| giver.items.like(g)}.compact
        beverages = grams.map{|g| giver.beverages.like(g)}.compact
        stuff = [items, beverages].flatten.compact.uniq

        return false unless stuff.present?

        if stuff.count > 1
          return Alice::Handlers::Response.new(
            content: "I don't know if you mean #{stuff.map(&:name_with_article).join', '}, or what.",
            kind: :reply
          )
        end

        if stuff.last.is_cursed?
          return Alice::Handlers::Response.new(
            content: "You can't seem to let go of #{stuff.last.name_with_article}. Perhaps it's cursed?",
            kind: :reply
          )
        end

        return stuff.last.transfer_to(recipient) && Alice::Handlers::Response.new(
          content: Alice::Util::Randomizer.give_message(giver.proper_name, recipient.proper_name, stuff.last.name_with_article),
          kind: :reply
        )

      end

      def self.process_unknown
        Alice::Handlers::Response.new(content: "I'm pretty sure that you don't have that.", kind: :reply)
      end
    
    end

  end

end