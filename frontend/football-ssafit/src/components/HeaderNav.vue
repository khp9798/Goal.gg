<template>
    <div>
        헤더네비게이션 입니다
        <RouterLink :to="{name : 'home'}">로고</RouterLink>|
        <RouterLink :to="{name : 'stadiumlist'}">경기장</RouterLink>|
        <RouterLink :to="{name : 'userview'}">유저 정보</RouterLink>|
        <RouterLink :to="{name:'match'}">매치 일정</RouterLink> | 
        <RouterLink :to="{name:'reservation'}">예약 확인</RouterLink>
        <RouterLink :to="{name : 'loginview'}" v-if="!userstore.loginUser.name">로그인</RouterLink>
        <a @click="tryLogout" v-if="userstore.loginUser.name">로그아웃</a>
    </div>
</template>

<script setup>

import { RouterLink } from 'vue-router/dist/vue-router';
import { useUserStore } from '@/stores/user';
const userstore = useUserStore()
function tryLogout(){
    userstore.tryLogout()
}

</script>

<style lang="scss" scoped>

</style>