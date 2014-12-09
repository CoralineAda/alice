module Alice

  module Filters

    class Dazed

      def process(text)
        if Util::Randomizer.one_chance_in(10)
          filtered = text.split[0..rand(4)].join(' ')
          filtered << "... "
          filtered << "#{Util::Randomizer.exclamation} "
          filtered << "You just #{['hallucinated', 'saw', 'imagined'].sample} "
          filtered << "#{Util::Randomizer.thing} #{Util::Randomizer.action}"
          filtered
        else
          text
        end
      end

    end

  end

end