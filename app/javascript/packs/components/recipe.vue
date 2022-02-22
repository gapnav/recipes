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
            v-bind:class="{available: ingredient.available}"
          )
            | {{ ingredient.title }}
            va-icon.ml-1(
              v-if="!ingredient.available"
              name="check"
              color="info"
              size="small"
              v-on:click.stop="markIngredient(ingredient.ingredient_id, true)"
            )
            va-icon.ml-1(
              name="close"
              color="danger"
              size="small"
              v-on:click.stop="markIngredient(ingredient.ingredient_id, false)"
            )

</template>

<script>
export default {
  props: ['recipe'],

  data(){
    return {
      full: false
    }
  },

  methods: {
    markIngredient(ingerdient_id, available){
      this.$emit('mark_ingredient', ingerdient_id, available);
    }
  }
}
</script>

<style scoped lang="scss">
  .va-list-item-label {
    ul {
      li {
        &.available {
          color: var(--va-info)
        }
      }
    }
  }
</style>