<template>
    <div class="container mt-5">
        <h2>예약 리스트</h2>
        <table class="table">
            <thead>
                <tr>
                    <th>매치명</th>
                    <th>시작 시간</th>
                    <th>종료 시간</th>
                    <th>상태</th>
                    <th>예약 시간</th>
                </tr>
            </thead>
            <tbody>
                <ReservationListItem v-for="reservation in store.reservationList" :key="reservation.id"
                :reservation="reservation"  />
            </tbody>
        </table>
    </div>
</template>

<script setup>
import { onMounted } from 'vue';
import ReservationListItem from './ReservationListItem.vue';
import { useReservationStore } from '@/stores/reservation';
import { useUserStore } from '@/stores/user';
import router from '@/router';


const store = useReservationStore()


</script>

<style scoped></style>