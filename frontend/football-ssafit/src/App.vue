<template>
  <div>
    <!-- 헤더뷰,라우터뷰 -->
     
    <HeaderNav/>

    <RouterView/>
    <FooterView/>
  </div>
</template>

<script setup>

import { RouterView } from 'vue-router/dist/vue-router';
import HeaderNav from './components/HeaderNav.vue';
import FooterView from './components/FooterView.vue';

</script>

<style lang="scss" scoped>

</style>