<template>
  <div class="page">
    <navbar></navbar>

    <div v-if="app" class="container">
      <div class="app-name">{{app.name}}</div>
      <div class="app-actions">
        <div class="app-new-device">
          <input type="text" class="new-device-name">
          <button class="new-device-button" @click="addDevice">Add device</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import api from 'lib/api';

  export default {
    components: { navbar: require('components/navbar.vue') },
    data() {
      return {
        app: null
      }
    },
    methods: {
      addDevice() {
        console.log('addDevice');
      }
    },
    created() {
      api.app(api.user, this.$route.params['name']).then(app => {
        this.app = app.content.application;
      });
    }
  }
</script>
