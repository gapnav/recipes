<template lang="pug">
va-list-item.recipe(
  v-bind:class="{pointer: recipe.ingredients.length > 5}"
  v-on:click="full = !full"
)
  va-list-item-section(avatar)
    va-avatar
      img(v-bind:src="recipe.image")
    va-list-item-section
      va-list-item-label {{ recipe.title }}
      va-list-item-label(v-bind:lines="full ? 9999 : 5")
        ul
          li(
            v-for="ingredient in recipe.ingredients"
            v-bind:key="ingredient.id"
          ) {{ ingredient.title }}

</template>

<script>
import Recipe from './recipe.vue';

export default {
  props: ['recipe'],

  data(){
    return {
      full: false
    }
  }
}
</script>
