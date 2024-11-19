<template>
    <div>
        회원가입 입니다.
    </div> 
    <form @submit.prevent="trySignup">
        <label for="userid">아이디</label>
        <input type="text" id="userid" v-model="trySignupUser.userid"/>
        <hr>
        <label for="password">비밀번호</label>
        <input type="text" id="password" v-model="trySignupUser.password"/>
        <hr>
        <label for="passwordcheck">비밀번호 확인</label>
        <input type="text" id="passwordcheck" v-model="trySignupUser.passwordcheck"/>
        <hr>
        <label for="email">이메일</label>
        <input type="text" id="email" v-model="trySignupUser.email"/>
        <hr>
        <label for="phoneNumber">휴대전화 번호</label>
        <input type="text" id="phoneNumber" v-model="trySignupUser.phoneNumber"/>
        <hr>
        <label for="name">이름</label>
        <input type="text" id="name" v-model="trySignupUser.name"/>
        <hr>
        <label for="role">역할</label>
        <input type="text" id="role" v-model="trySignupUser.role"/>
        <hr>
        <label for="position">포지션</label>
        <input type="text" id="position" v-model="trySignupUser.position"/>
        <hr>
        <label for="tier">티어</label>
        <input type="text" id="tier" v-model="trySignupUser.tier"/>
        <hr>
        <button type="submit">로그인</button>
    </form>
</template>

<script setup>
import { useUserStore } from '@/stores/user'; //유저 스토어 임포트
import { ref } from 'vue';
const userstore = useUserStore() // 유저 스토어 사용
const trySignupUser = ref({ // 입력된 로그인 정보
    userid : '',
    password : '',
    passwordcheck : '',
    email :'',
    phoneNumber :'',
    name :'',
    role : '',
    position : '',
    tier : '',
})

function trySignup() { // 로그인 시도
    userstore.trySignup(trySignupUser.value)
}

</script>

<style lang="scss" scoped>

</style>