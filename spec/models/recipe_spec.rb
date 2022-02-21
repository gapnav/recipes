require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:meaningful_ingredients) do
    # get counts of ingredients usages
    result = RecipesIngredient.all.group(:ingredient_id).count
    # get 100 most used ingredients and take random 10 of them
    result.to_a.sort_by(&:last).last(100).sample(20).map(&:first)
  end
  let(:available) {|example| example.metadata[:available] ? meaningful_ingredients.first(10) : []}
  let(:not_available) {|example| example.metadata[:not_available] ? meaningful_ingredients.first(10) : []}
  let(:count) { 10 }

  describe '#relevant' do
    before do
      relevant_result = Recipe.relevant(available: available, not_available: not_available, count: 10)
      relevant_result.map!{|r| [r.id, r.recipes_ingredients.map(&:ingredient_id)]}

      check_result = RecipesIngredient.all
      if not_available&.any?
        skip_r_ids = RecipesIngredient.where(ingredient_id: not_available).pluck(:recipe_id).uniq
        check_result = check_result.where.not(recipe_id: skip_r_ids) if skip_r_ids&.any?
      end
      check_result = check_result.to_a.group_by(&:recipe_id).map{|r_id, ri| [r_id, ri.map(&:ingredient_id)]}
      check_result = check_result.sort_by do |k, v|
        result = available&.any? ? v.count{|i_id| !available.include?(i_id)} : v.count
        result = result * 10**6 - k
      end
      check_result = check_result.first(count)

      # p relevant_result, check_result
      expect(relevant_result.map(&:first)).to eq check_result.map(&:first)
      relevant_result.length.times do |i|
        expect(relevant_result.map(&:last)[i]).to match_array check_result.map(&:last)[i]
      end
    end

    it 'without available or not available ingredients' do; end

    it 'with available ingredients', :available do; end

    it 'with not available ingredients', :not_available do; end

    it 'without both available and not available ingredients', :available, :not_available do; end
  end
end
