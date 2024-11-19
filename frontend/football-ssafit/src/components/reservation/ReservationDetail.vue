<template>
    <div>
        {{ route.params.id }}번 예약의 상세 페이지입니다.
    </div>
</template>

<script setup>
import { useRoute } from 'vue-router';

const route = useRoute()
</script>

<style scoped>

</style>