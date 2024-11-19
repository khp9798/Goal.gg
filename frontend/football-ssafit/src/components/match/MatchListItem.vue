<template>
    <div>
        <li @click="goMatchDetail">
            매치 리스트 아이템입니다.
        </li>
    </div>
</template>

<script setup>
import router from '@/router';


const goMatchDetail = function(){
    router.push({name:'matchDetail', params : {id : 1}})
}
</script>

<style scoped>

</style>