<template>
    <div class="container">
        경기장 리스트입니다
        <div class="justify-content-start" v-if="stadiumstore.stadiumlist.length>0">
            <StadiumListItem v-for="stadium in stadiumstore.stadiumlist" :stadium="stadium" />
        </div>
        <h2 v-else>검색된 결과가 없습니다..</h2>
    </div>

</template>

<script setup>

import { useStadiumStore } from '@/stores/stadium';
import StadiumListItem from './StadiumListItem.vue';
import { onMounted } from 'vue';
import { useRoute } from 'vue-router';
const stadiumstore = useStadiumStore()

onMounted(() => {
    if(stadiumstore.stadiumlist.length == 0){
        stadiumstore.getStadiumList()
    }
})
</script>

<style lang="scss" scoped></style>