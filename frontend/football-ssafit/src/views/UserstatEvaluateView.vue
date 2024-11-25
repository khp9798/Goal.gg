<template>
    <div>  
        <UserstatEvaluateList/>
    </div>
</template>

<script setup>
import UserstatEvaluateList from '@/components/userstat/UserstatEvaluateList.vue';
import { useReservationStore } from '@/stores/reservation';

const reservationstore = useReservationStore()

</script>

<style scoped>

</style>