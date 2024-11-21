<template>
    <div class="container mt-5">

        <h5 class="mb-4">유저 능력치</h5>

        <div class="card p-4 shadow" v-if="userstore.loginUser.userid">
            <!-- 유저 정보 -->
            <div class="row">
                <div class="col-md-4">
                    <h6>이름: {{ userstore.loginUser.name }}</h6>
                    <h6>포지션: {{ userstore.loginUser.position }}</h6>
                    <h6>티어: {{ userstore.loginUser.tier }}</h6>
                </div>
                <!-- 유저 능력치 -->
                <div class="col-md-4">
                    <h6>능력치</h6>
                    <div class="mb-2">슛: <span class="fw-bold">{{ userstore.loginUserStat.shoot }}</span></div>
                    <div class="mb-2">패스: <span class="fw-bold">{{ userstore.loginUserStat.pass }}</span></div>
                    <div class="mb-2">속력: <span class="fw-bold">{{ userstore.loginUserStat.speed }}</span></div>
                    <div class="mb-2">체력: <span class="fw-bold">{{ userstore.loginUserStat.stamina }}</span></div>
                    <div class="mb-2">드리블: <span class="fw-bold">{{ userstore.loginUserStat.dribble }}</span></div>
                </div>
                <!-- 닮은 선수 -->
                <div class="col-md-4 text-center">
                    <h6>나와 닮은 선수</h6>
                    <div class="border p-3 rounded">결제가 필요합니다</div>
                </div>
            </div>
        </div>

        <div class="card p-4 shadow" v-else>
            <!-- 기본 예시 데이터 -->
            <div class="row">
                <div class="col-md-4">
                    <h6>이름: 김철수</h6>
                    <h6>포지션: 공격수</h6>
                    <h6>티어: 다이아몬드</h6>
                </div>
                <!-- 유저 능력치 -->
                <div class="col-md-4">
                    <h6>능력치</h6>
                    <div class="mb-2">슛: <span class="fw-bold">83</span></div>
                    <div class="mb-2">패스: <span class="fw-bold">76</span></div>
                    <div class="mb-2">속력: <span class="fw-bold">81</span></div>
                    <div class="mb-2">체력: <span class="fw-bold">81</span></div>
                    <div class="mb-2">드리블: <span class="fw-bold">80</span></div>
                </div>
                <!-- 닮은 선수 -->
                <div class="col-md-4 text-center">
                    <h6>나와 닮은 선수</h6>
                    <img src="../../assets/Son.PNG" alt="Logo" width="180rem" height="260rem">
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useUserStore } from "@/stores/user";
import { onMounted } from "vue";

const userstore = useUserStore();

onMounted(()=>{
    console.log('마운트됏음')
    console.log(userstore.loginUser.userid)
    if(userstore.loginUser.userid){
        userstore.getUserstat(userstore.loginUser.userid)
    }
})
</script>

<style scoped>
.card {
    background-color: #f8f9fa;
}
</style>