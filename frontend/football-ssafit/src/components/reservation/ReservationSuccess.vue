<template>
    <div>

    </div>
</template>

<script setup>
import router from '@/router';
import { useUserStore } from '@/stores/user';
import axios from 'axios';
import { onMounted } from 'vue';
import { useRoute } from 'vue-router';

const route= useRoute()

const userstore =  useUserStore()
onMounted(()=>{
    alert("예약 성공")
    router.replace({name:'matchDetail', params:route.params.id})

    axios({
        url : "http://localhost:8080/reservations",
        method : 'post',
        params : {userId : userstore.loginUser.userid, matchId : route.params.id}
    })
    .then(()=>{
        console.log("예약 성공")
    })
    .catch(()=>{
        console.log("예약 실패")
        console.log(userstore.loginUser.userid)
        console.log(route.params.id)
    })
})
</script>

