module Alice

  module Filters

    class Dazed

      def process(text)
        if Alice::Util::Randomizer.one_chance_in(3)
          filtered = text.split[0..rand(4)].join(' ')
          filtered << "... "
          filtered << "#{Alice::Util::Randomizer.exclamation} "
          filtered << "You just #{['hallucinated', 'saw', 'imagined'].sample} "
          filtered << "#{Alice::Util::Randomizer.thing} #{Alice::Util::Randomizer.action}"
          filtered
        else
          text
        end
      end
      
    end

  end

end