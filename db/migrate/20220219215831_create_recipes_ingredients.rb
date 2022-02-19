class CreateRecipesIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes_ingredients do |t|
      t.string :title
      t.references :recipe, index: false
      t.references :ingredient, index: true

      t.timestamps
    end

    add_index :recipes_ingredients, [:recipe_id, :ingredient_id]
  end
end
