<template>
    <div class="container mt-5">
        <h2>경기장 목록</h2>
        <div v-if="stadiumstore.stadiumlist.length>0" class="row row-cols-1 row-cols-md-2 g-4">
            <StadiumListItem v-for="stadium in stadiumstore.stadiumlist" :stadium="stadium" />
        </div>
        <h2 v-else>검색된 결과가 없습니다..</h2>
    </div>

</template>

<script setup>

import { useStadiumStore } from '@/stores/stadium';
import StadiumListItem from './StadiumListItem.vue';
import { onMounted, onUnmounted } from 'vue';
import { useRoute } from 'vue-router';
const stadiumstore = useStadiumStore()

onMounted(() => {
    if(stadiumstore.stadiumlist.length == 0){
        stadiumstore.getStadiumList()
    }
})

</script>

<style lang="scss" scoped></style>