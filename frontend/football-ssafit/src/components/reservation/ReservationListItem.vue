<template>
    <div>
        <li @click="goDetail">
            예약 아이템입니다.
        </li>
    </div>
</template>

<script setup>
import router from '@/router';



const goDetail = function(){
    router.push({name:'reservationDetail',params : {id : 2}})
}
</script>

<style scoped>

</style>