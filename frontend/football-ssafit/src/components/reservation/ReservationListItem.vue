<template>
    <div>
        <li @click="goDetail">
            {{ props.reservation.name }}
            {{ props.reservation.reservationDate.replace('T', ' ').slice(0, 16) }}
            경기 타임 : {{ props.reservation.startTime.replace('T', ' ').slice(0, 16) }} ~ 
            {{ props.reservation.endTime.replace('T', ' ').slice(0, 16) }}
        </li>
    </div>
</template>

<script setup>
import router from '@/router';

const props =  defineProps({
    reservation : Object
})

const goDetail = function(){
    router.push({name:'matchDetail',params : {id : props.reservation.matchId}})
}
</script>

<style scoped>
li{
    
}
</style>