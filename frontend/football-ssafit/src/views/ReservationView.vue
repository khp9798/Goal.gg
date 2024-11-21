<template>
    <div>
        <h2>예약 확인 뷰입니다.</h2>
        <ReservationList v-if="userstore.loginUser.userid"/>
    </div>
</template>

<script setup>
import ReservationList from '@/components/reservation/ReservationList.vue';
import { useUserStore } from '@/stores/user';
const userstore = useUserStore()


</script>

<style lang="scss" scoped>

</style>