<template>
    <div class="card mx-3 flex-shrink-0" style="width: 25rem;" @click="goDetail">
        <img :src="props.match.image" class="card-img-top" alt="..." width="300" height="200">
        <div class="card-body text-center">
            <h5 class="card-title">{{props.match.name}}</h5>
            <p class="card-text">{{ props.match.stadiumName }}</p>
        </div>
    </div>
</template>

<script setup>
import router from '@/router';



const props = defineProps({
    match: Object
})

const goDetail = function(){
    router.push({name:'matchDetail',params:{id:props.match.id}})
}
</script>

<style lang="scss" scoped></style>