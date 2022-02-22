<template lang="pug">
.recipes
  va-progress-circle(v-if="loading" indeterminate)
  .container(v-else)
    va-list(v-else)
      recipe(v-for="recipe in recipes" v-bind:key="recipe.id" v-bind:recipe="recipe")

</template>

<script>
import Recipe from './recipe.vue';

export default {
  components: { Recipe },

  data(){
    return {
      loading: false,

      recipes: [],

      ingredients: {
        to_ask: []
      }
    }
  },

  created(){
    this.loadRecipies();
  },

  methods: {
    loadRecipies(){
      this.loading = true;
      this.axios.get('/recipes.json', {params: {}}).then((response) => {
        this.recipes = response.data.recipes;
        this.ingredients.to_ask = response.data.ingredients
      }).finally(() => {
        this.loading = false;
      })
    }
  }
}
</script>
