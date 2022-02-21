class Recipe < ApplicationRecord
  has_many :recipes_ingredients, dependent: :delete_all, inverse_of: :recipe
  accepts_nested_attributes_for :recipes_ingredients
  has_many :ingredients, through: :recipes_ingredients

  validates :title, presence: true

  scope :relevant, -> (available: nil, not_available: nil, count: 10, preload_ingredients: true) do
    sql = 'SELECT recipes.* FROM recipes'
    sql << ' LEFT JOIN recipes_ingredients ON recipes_ingredients.recipe_id = recipes.id'

    where = []

    # skip the recipes which depend on not available ingredients
    if not_available&.any?
      where << 'recipes_ingredients.recipe_id NOT IN (
          SELECT DISTINCT recipe_id FROM recipes_ingredients WHERE ingredient_id IN (:not_available)
        )'
    end

    sql << " WHERE #{where.join ' AND '}" if where.any?
    sql << ' GROUP BY recipes.id'

    # prioritize the recipes with lower count of needed ingredients (excluding already confirmed as available)
    counter_filter = available&.any? ? 'FILTER (WHERE recipes_ingredients.ingredient_id NOT IN (:available))' : ''
    sql << " ORDER BY COUNT(recipes_ingredients.id) #{counter_filter} ASC, recipes.id DESC"

    sql << ' LIMIT :count'
    
    result = find_by_sql([sql, available: available, not_available: not_available, count: count])
    ActiveRecord::Associations::Preloader.new.preload(result, :recipes_ingredients) if preload_ingredients
    result
  end
end
