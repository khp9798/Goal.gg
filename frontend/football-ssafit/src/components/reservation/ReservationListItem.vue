<template>
    <tr @click="goDetail">
        <td>{{ props.reservation.name }}</td>
        <td>{{ props.reservation.startTime.replace('T', ' ').slice(0, 16) }}</td>
        <td>{{ props.reservation.endTime.replace('T', ' ').slice(0, 16) }}</td>
        <td>{{ props.reservation.status }}</td>
        <td>{{ props.reservation.reservationDate.replace('T', ' ').slice(0, 16) }}</td>
    </tr>
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