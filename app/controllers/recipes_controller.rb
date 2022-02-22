class RecipesController < ApplicationController
  def index
    @recipes = Recipe.relevant
    @ingredients = Ingredient.to_ask
  end
end
