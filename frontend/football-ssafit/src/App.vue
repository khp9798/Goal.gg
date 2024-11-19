<template>
  <div>
    <!-- 헤더뷰,라우터뷰 -->
     
    <HeaderNav/>
    <RegionTest/>

    <RouterView/>
  </div>
</template>

<script setup>

import { RouterView } from 'vue-router/dist/vue-router';
import HeaderNav from './components/HeaderNav.vue';

</script>

<style lang="scss" scoped>

</style>