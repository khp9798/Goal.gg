<template>
    <div>
        <div>
            이미지입니다.
        </div>
        
        {{ route.params.id }}번 매치의 디테일입니다.
    </div>
</template>

<script setup>
import { useRoute } from 'vue-router';

const route = useRoute()
</script>

<style lang="scss" scoped>

</style>