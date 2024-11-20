<template>
    <div @click="goStadiumDetail" class="card mx-3 flex-shrink-0" style="width: 25rem;">
        <img :src="stadium.image" class="card-img-top" alt="..." width="300" height="200">
        <div class="card-body text-center">
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