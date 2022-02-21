require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  let(:meaningful_ingredients) do
    # get counts of ingredients usages
    result = RecipesIngredient.all.group(:ingredient_id).count
    # get 100 most used ingredients and take random 10 of them
    result.to_a.sort_by(&:last).last(100).sample(20).map(&:first)
  end
  let(:available) {|example| example.metadata[:available] ? meaningful_ingredients.first(10) : []}
  let(:not_available) {|example| example.metadata[:not_available] ? meaningful_ingredients.first(10) : []}
  let(:count) { 10 }

  describe '#to_ask' do
    before do
      to_ask_result = Ingredient.to_ask(available: available, not_available: not_available, count: 10).map(&:id)

      check_result = RecipesIngredient.all
      check_result = check_result.where.not(ingredient_id: available) if available&.any?
      if not_available&.any?
        skip_r_ids = RecipesIngredient.where(ingredient_id: not_available).pluck(:recipe_id).uniq
        check_result = check_result.where.not(recipe_id: skip_r_ids) if skip_r_ids&.any?
      end
      check_result = check_result.to_a.group_by(&:ingredient_id).map{|k,v| [k, v.count]}
      check_result = check_result.sort_by{|k, v| -k -v*10**6}
      check_result = check_result.first(count).map(&:first)

      # p to_ask_result, check_result
      expect(to_ask_result).to eq check_result
    end

    it 'without available or not available ingredients' do; end

    it 'with available ingredients', :available do; end

    it 'with not available ingredients', :not_available do; end

    it 'without both available and not available ingredients', :available, :not_available do; end
  end
end
