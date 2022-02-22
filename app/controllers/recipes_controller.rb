class RecipesController < ApplicationController
  def index
    @recipes = Recipe.relevant(available: params[:available], not_available: params[:not_available])
    
    @selected = {available: [], not_available: []}
    [:available, :not_available].each do |key|
      @selected[key] = Ingredient.where(id: params[key]) if params[key]
    end
    
    @ingredients = Ingredient.to_ask(available: params[:available], not_available: params[:not_available])
  end
end
