// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import { createApp } from 'vue'
import { VuesticPlugin } from 'vuestic-ui'
import 'vuestic-ui/dist/vuestic-ui.css'
import axios from 'axios'
import VueAxios from 'vue-axios'
import App from '../app.vue'

Rails.start()
// Turbolinks.start()
ActiveStorage.start()

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App);
  app.use(VuesticPlugin)
  app.use(VueAxios, axios)
  app.mount("#vue-app");
});


Array.prototype.uniq = function(){
  let result = [];
  this.forEach(x => {
    if (result.indexOf(x) < 0) result.push(x);
  });
  return result;
};

Array.prototype.intersection = function(other) {
  let result = this.filter((x) => {
    return (other.indexOf(x) > -1);
  });
  return result.uniq();
};

Array.prototype.diff = function(other) {
  return this.filter((x) => {
    return (other.indexOf(x) < 0);
  });
};

Array.prototype.equal = function(other) {
  if (this.length !== other.length) return false;
  return JSON.stringify(this) === JSON.stringify(other);
};
