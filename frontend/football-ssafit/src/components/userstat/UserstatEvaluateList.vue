<template>
  <div class="card-container">
    <div class="card" v-for="user in reservationstore.useravgstatList">
      <UserstatEvaluateItem :user="user" />
    </div>
  </div>
</template>

<script setup>
import { useReservationStore } from '@/stores/reservation';
import UserstatEvaluateItem from './UserstatEvaluateItem.vue';

const reservationstore = useReservationStore();
</script>

<style scoped>
.card-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  padding: 20px;
}

.card {
  border: 1px solid #ccc;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  padding: 16px;
  background-color: #fff;
}
</style>
