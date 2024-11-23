<template>
    <div>
        <ReservationList v-if="userstore.loginUser.userid"/>
    </div>
</template>

<script setup>
import ReservationList from '@/components/reservation/ReservationList.vue';
import { useUserStore } from '@/stores/user';
const userstore = useUserStore()


</script>

<style scoped>

</style>