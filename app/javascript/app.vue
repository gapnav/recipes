<template lang="pug">
va-content
  .main-container
    h1 Recipes Database
    recipes

</template>

<script>
import Recipes from 'packs/components/recipes.vue';

export default {
  components: { Recipes },

  data() {
      return {
        message: "Hello Vue!"
      }
    }
  }
</script>

<style scoped>
  .main-container {
    padding: 10px;
  }
</style>