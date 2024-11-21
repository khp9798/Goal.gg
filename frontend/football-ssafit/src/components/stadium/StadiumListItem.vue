<template>
    <div class="card" @click="goStadiumDetail">
      <img :src="stadium.image" class="card-img-top mt-3" alt="..." width="500" height="400">
      <div class="card-body">
        <h5 class="card-title">{{stadium.name}}</h5>
        <p class="card-text">{{ stadium.address }}</p>
      </div>
    </div>
</template>

<script setup>
import router from '@/router';
const props = defineProps({
    stadium: Object
})

function goStadiumDetail(){
    router.push({name : 'stadiumdetail', params : {id : props.stadium.id}})
}

</script>

<style scoped>

</style>