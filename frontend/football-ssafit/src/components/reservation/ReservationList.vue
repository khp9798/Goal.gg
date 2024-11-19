<template>
    <div>
        예약 리스트
        <ol>
            <ReservationListItem v-for="reservation in store.reservationList" :key="reservation.id"
                :reservation="reservation" />
        </ol>

    </div>
</template>

<script setup>
import { onMounted } from 'vue';
import ReservationListItem from './ReservationListItem.vue';
import { useReservationStore } from '@/stores/reservation';


const store = useReservationStore()
onMounted(() => {
    store.getList()
})

</script>

<style scoped></style>