import api from 'lib/api';

export default {
  components: { navbar: require('components/navbar.vue') },
  data() {
    return {
      apps: []
    };
  },
  methods: {
    url(app) {
      return `/apps/${app.name}`
    },
    show(e) {
      this.$router.push(e.target.dataset.href);
    }
  },
  mounted() {
    api.apps(api.user).then(res => {
      this.apps = res.content.applications;
    });
  }
};
