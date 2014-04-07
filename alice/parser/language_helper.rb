module Alice

  module Parser

    module LanguageHelper

      ARTICLES = [
        'a', 'the', 'of', 'an', 'to', 'and'
      ]

      NUMBERS = {
        'one' => '1',
        'two' => '2',
        'three' => '3',
        'four' => '4',
        'five' => '5',
        'six' => '6',
        'seven' => '7',
        'eight' => '8',
        'nine' => '9',
        'ten' => '10'
      }

      IDENTIFIERS = NUMBERS.keys + NUMBERS.values + ARTICLES

    end

  end

end
