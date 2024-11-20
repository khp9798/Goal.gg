<template>
    <div>
        경기장 상세입니다
        <div>경기장 이미지</div>
        <img :src="stadiumstore.stadium.image" class="card-img-top" alt="..." width="300" height="200">
        <div>경기장 이름</div>
        {{ stadiumstore.stadium.name }}
        <hr>
        <div>경기장 주소</div>
        {{ stadiumstore.stadium.address }}
        <hr>
        <div>경기장 가격</div>
        {{ stadiumstore.stadium.price }}
        <hr>
        <div>경기장 수용인원</div>
        {{ stadiumstore.stadium.capacity }}
        <StadiumMatch :stadiumid="route.params.id"/>
    </div>
</template>

<script setup>
import { useStadiumStore } from '@/stores/stadium';
import { onMounted } from 'vue';
import { useRoute } from 'vue-router';
import StadiumMatch from '@/components/stadium/StadiumMatch.vue'

const route = useRoute()
const stadiumstore = useStadiumStore()
onMounted(()=>{
    stadiumstore.getStadium(route.params.id)
})

</script>

<style lang="scss" scoped>

</style>