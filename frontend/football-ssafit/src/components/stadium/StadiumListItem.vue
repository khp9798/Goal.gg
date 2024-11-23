<template>
  <div class="card h-100 shadow-sm" @click="goStadiumDetail">
    <img :src="stadium.image" class="card-img-top img-fluid rounded" alt="stadium image"
      style="height: 200px; object-fit: cover;" />
    <div class="card-body">
      <h5 class="card-title">{{ stadium.name }}</h5>
      <p class="card-text text-muted">위치: {{ stadium.address }}</p>
    </div>
  </div>
</template>

<script setup>
import router from "@/router";

const props = defineProps({
  stadium: Object,
});

function goStadiumDetail() {
  router.push({ name: "stadiumdetail", params: { id: props.stadium.id } });
}
</script>

<style scoped>
.card {
  cursor: pointer;
  transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
}

.card-title {
  font-size: 1.25rem;
  font-weight: bold;
  color: #343a40;
}

.card-text {
  font-size: 0.9rem;
  margin-bottom: 0;
  color: #6c757d;
}
</style>
