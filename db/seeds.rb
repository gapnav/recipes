# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

recipes = JSON.parse(File.read(Rails.root.join('db/files/recipes-english.json')))

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
