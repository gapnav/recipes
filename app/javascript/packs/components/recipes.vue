<template lang="pug">
.recipes
  va-progress-circle(v-if="loading" indeterminate)
  .container(v-else)
    .row
      .flex.xs6
        h4 Relevant recipes
        va-list
          recipe(
            v-for="recipe in recipes"
            v-bind:key="recipe.id"
            v-bind:recipe="recipe"
            v-on:mark_ingredient="markIngredient"
          )

      .flex.xs6
        template(v-if="ingredients.available.length")
          h4 You have:
          va-chip.ma-1(
            v-for="ingredient in ingredients.available"
            v-bind:key="'available_'+ingredient.id"
            color="info"
            icon="close"
            v-on:click="removeSelected(ingredient.id)"
          ) {{ ingredient.title }}
        template(v-if="ingredients.not_available.length")
          h4 You don't have:
          va-chip.ma-1(
            v-for="ingredient in ingredients.not_available"
            v-bind:key="'not_available_'+ingredient.id"
            color="danger"
            icon="close"
            v-on:click="removeSelected(ingredient.id)"
          ) {{ ingredient.title }}

        h4 Do you have anything of these pupular ingredients?        
        va-checkbox(
          v-for="ingredient in ingredients.to_ask"
          v-bind:key="'checkbox_'+ingredient.id"
          v-model="available"
          v-bind:array-value="ingredient.id.toString()"
          v-bind:label="ingredient.title"
        )
        va-button.my-2(v-on:click="loadRecipes") Submit


</template>

<script>
import Recipe from './recipe.vue';

export default {
  components: { Recipe },

  data(){
    return {
      loading: false,

      recipes: [],

      ingredients: {},

      available: []
    }
  },

  created(){
    this.loadRecipes();
  },

  methods: {
    loadRecipes(e){
      this.loading = true;

      let available = [];
      let not_available = [];

      if (e) { // if form submitted
        available = available.concat(this.available);
        if (this.ingredients.to_ask && e) {
          // we use this toString duct-tape because va-checkbox.arra-value requires a string
          not_available = this.ingredients.to_ask.map(i => i.id.toString()).diff(this.available);
        }
      }

      if (this.ingredients.available) {
        available = available.concat( this.ingredients.available.map(i => i.id) )
      }
      if (this.ingredients.not_available) {
        not_available = not_available.concat( this.ingredients.not_available.map(i => i.id) )
      }

      let params = {
        available: available,
        not_available: not_available
      }

      this.axios.get('/recipes.json', {params: params}).then((response) => {
        this.recipes = response.data.recipes;
        this.ingredients = response.data.ingredients;
        this.available = []
      }).finally(() => {
        this.loading = false;
      })
    },

    removeSelected(ingredient_id){
      ['available', 'not_available'].forEach(key => {
        this.ingredients[key] = this.ingredients[key].filter(i => i.id !== ingredient_id);
      });
      this.loadRecipes();
    },

    markIngredient(ingredient_id, available){
      let [add_key, remove_key] = ['not_available', 'available'];
      if (available) [add_key, remove_key] = ['available', 'not_available'];
      this.ingredients[remove_key] = this.ingredients[remove_key].filter(i => i.id !== ingredient_id);
      this.ingredients[add_key].push({id: ingredient_id});
      this.loadRecipes();
    }
  }
}
</script>
