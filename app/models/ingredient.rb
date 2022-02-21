class Ingredient < ApplicationRecord
  has_many :recipes_ingredients
  
  validates :title, presence: true

  scope :to_ask, -> (available: nil, not_available: nil, count: 10) do
    sql = 'SELECT ingredients.* FROM ingredients'
    sql << ' LEFT JOIN recipes_ingredients ON recipes_ingredients.ingredient_id = ingredients.id'

    where = []
    
    # skip already confirmed ingredients (no need to ask about them again)
    where << 'ingredients.id NOT IN (:available)' if available&.any?
    
    # skip the ingredients which are related to the recipes which depend on not available ingredients
    if not_available&.any?
      where << 'recipes_ingredients.recipe_id NOT IN (
          SELECT DISTINCT recipe_id FROM recipes_ingredients WHERE ingredient_id IN (:not_available)
        )'
    end

    sql << " WHERE #{where.join ' AND '}" if where.any?
    sql << ' GROUP BY ingredients.id'

    # prioritize the most meaningful ingredients (with higher count of usages)
    sql << ' ORDER BY COUNT(recipes_ingredients.id) DESC, ingredients.id DESC'

    sql << ' LIMIT :count'
    
    find_by_sql([sql, available: available, not_available: not_available, count: count])
  end

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
