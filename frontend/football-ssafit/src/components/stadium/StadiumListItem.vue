<template>
    <div @click="goStadiumDetail">
        경기장 리스트 아이템입니다 이미지
    </div>

</template>

<script setup>
import router from '@/router';

function goStadiumDetail(){
    router.push({name : 'stadiumdetail', params : {id : 7}})
}

</script>

<style scoped>

</style>