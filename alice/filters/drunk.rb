module Alice

  module Filters

    class Drunk

      def process(text)
        to_process = text.split
        positions = to_process.sample(to_process.length / 2).map{|word| to_process.index(word)}.sort
        to_process.inject([]) do |a, word|
          if positions.include?(a.length)
            a << filtered(word)
          else
            a << word
          end
          a
        end.join(' ')
      end

      def filtered(text)
        if rand(3) == 1
          return text + (text[-1] * (rand(2)))
        else
          return text
        end
        
      end

    end

  end

end