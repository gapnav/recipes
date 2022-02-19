class Ingredient < ApplicationRecord
  has_many :recipes_ingredients
  
  validates :title, presence: true

  class << self
    def clean_title(title)
      words = title.downcase.split
      clean_title_words(words).join(' ')
    end

    private

    def clean_title_words(words)
      meaningful_word?(words.first) ? words : clean_title_words(words[1..-1])
    end

    def meaningful_word?(word)
      return false if word.length < 3
      return false if word.gsub(/\d/,'').length < 3
    
      irrelevant_words = %w(
        few cup cups tablespoon tablespoons teaspoon teaspoons large small medium and finely
        pound pound\) pounds ounce\) ounce ounces slice slices pinch pinches bunch bunches quart quarts drops inch\)
        package packages can cans jar whole each bag cold packet box container envelope
        chopped shredded sliced grated minced crushed cubed coarsely warm peeled diced
      )
      return !irrelevant_words.include?(word)
    end
  end
end
