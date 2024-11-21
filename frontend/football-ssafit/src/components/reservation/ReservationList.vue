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
import { useUserStore } from '@/stores/user';
import router from '@/router';


const store = useReservationStore()
const userstore = useUserStore()
onMounted(() => {
    if(userstore.loginUser.userid){
        store.getList(userstore.loginUser.userid)
    } else{
        router.push({name :'loginview'})
    }
})

</script>

<style scoped></style>