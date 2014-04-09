module Alice

  class Sanitizer

    def self.sanitize(text)
      text.gsub("the the", "the")
      text.gsub("the ye", "ye")
      text.gsub("a a", "an a")
      text.gsub("a e", "an e")
      text.gsub("a i", "an i")
      text.gsub("a o", "an o")
      text.gsub('..', '.')
      text.gsub('  ', ' ')
      text
    end

  end

end