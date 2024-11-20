<template>
    <div>
        로그인입니다.
    </div> 

    
    <form @submit.prevent="tryLogin">
        <label for="userid">아이디</label>
        <input type="text" id="userid" v-model="tryLoginUser.userid"/>
        <hr>
        <label for="password">비밀번호</label>
        <input type="password" id="password" v-model="tryLoginUser.password"/>
        <hr>
        <button type="submit">로그인</button>
    </form>
    <RouterLink :to="{name : 'signup'}">회원가입</RouterLink>
</template>

<script setup>
import { useUserStore } from '@/stores/user'; //유저 스토어 임포트
import { ref } from 'vue';
import SignupView from './SignupView.vue';
const userstore = useUserStore() // 유저 스토어 사용
const tryLoginUser = ref({ // 입력된 로그인 정보
    userid : '',
    password : ''
})

function tryLogin() { // 로그인 시도
    userstore.tryLogin(tryLoginUser.value)
    tryLoginUser.value={};
}

</script>

<style lang="scss" scoped>

</style>