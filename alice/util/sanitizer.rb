module Alice

  module Util
    
    class Sanitizer

      def self.process(text)
        text ||= ""
        text.gsub!(" the the ", " the ")
        text.gsub!(" the ye ", " ye ")
        text.gsub!(" the a ", " the ")
        text.gsub!(" a the ", " a ")
        text.gsub!(" a a ", " a ")
        text.gsub!(" a ye ", " ye ")
        text.gsub!(" ye ye ", " ye ")
        text.gsub!(" ye a ", " ye ")
        text.gsub!(" an a ", " a ")
        text.gsub!(" a a", " an a")
        text.gsub!(" a e", " an e")
        text.gsub!(" a i", " an i")
        text.gsub!(" a o", " an o")
        text.gsub!(/^am/i, 'is')
        text.gsub!('..', '.')
        text.gsub!('!.', '!')
        text.gsub!('. .', '.')
        text.gsub!('  ', ' ')
        text.gsub!(' " ', ' "')
        text.gsub!(/ (A) /) {|s| s.downcase}
        text.gsub!(/ (The) /) {|s| s.downcase}
        text.gsub!(/ (An) /) {|s| s.downcase}
        text.gsub!(/ (Their) /) {|s| s.downcase}
        text.gsub!(/^ /, '')
        text
      end

      def self.initial_upcase(text)
        text.gsub(/^([a-z])/) {|s| s.upcase}
      end

      def self.initial_downcase(text)
        text.gsub(/^([A-Z])/) {|s| s.downcase}
      end

      def self.strip_pronouns(text)
        text.gsub!(/^I /i, '')
      end

      def self.ordinal(number)
        number == 1 && "1st" || number == 2 && "2nd" || number == 3 && "3rd" || "#{number}th"
      end

    end

  end

end