module ImportJson
  def self.import(limit: nil)
    recipes = JSON.parse(File.read(Rails.root.join('db/files/recipes-english.json')))
    recipes = recipes.sample(limit) if limit

    puts 'Create Ingredients'
    clean_titles = recipes.map{|recipe| recipe['ingredients']}.flatten.uniq
    clean_titles.map!{|title| Ingredient.clean_title title}
    clean_titles.uniq!
    Ingredient.create(
      clean_titles.map{|title| {title: title}}
    )
    ingredient_id_by_title = Ingredient.all.pluck(:title, :id).to_h
    
    puts 'Create Recipes'
    recipes_attrs = recipes.map do |recipe_data|
      ri_attrs = recipe_data['ingredients'].map do |title|
        {
          title: title, 
          ingredient_id: ingredient_id_by_title[Ingredient.clean_title(title)]
        }
      end
      recipe_data.slice('title', 'image').merge(
        recipes_ingredients_attributes: ri_attrs
      )
    end
    Recipe.create recipes_attrs    
  end
end
