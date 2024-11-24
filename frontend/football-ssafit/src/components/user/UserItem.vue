<template>
    <div class="container mt-5">
        <h2 class="mb-4">유저 능력치</h2>

        <!-- 로그인한 유저 정보 -->
        <div class="card p-4 shadow d-flex" v-if="userstore.loginUser.userid">
            <div class="row align-items-center">

                <!-- 유저 정보 -->
                <div class="col-md-3 text-center">
                    <img :src="`/src/assets/tier/${userstore.loginUser.tier}.webp`" alt="유저 티어"
                        class="img-fluid rounded-circle mb-3" width="120" height="120">
                    <h4 class="mb-2">{{ userstore.loginUser.name }}</h4>
                    <p class="text-muted mb-1"><strong>포지션:</strong> {{ userstore.loginUser.position }}</p>
                    <p class="text-muted"><strong>티어:</strong> {{ userstore.loginUser.tier }}</p>
                </div>

                <!-- 유저 능력치 차트 -->
                <div class="col-md-9">
                    <UserstatItem class="d-flex" />
                </div>

            </div>
        </div>

        <!-- 비로그인 상태 -->
        <div class="card p-5 shadow" v-else>
            <div class="row align-items-center">

                <!-- 유저 기본 정보 -->
                <div class="col-md-3 text-center">
                    <img src="/src/assets/tier/unranked.webp" alt="기본 티어" class="img-fluid rounded-circle mb-3" width="120"
                        height="120">
                    <h4 class="mb-2">손흥민</h4>
                    <p class="text-muted mb-1"><strong>포지션:</strong> Forward</p>
                    <p class="text-muted"><strong>티어:</strong> Unranked</p>
                </div>

                <!-- 유저 능력치 차트 -->
                <div class="col-md-9">
                    <UserstatItem class="d-flex" />
                </div>

            </div>
        </div>
    </div>
</template>

<script setup>
import { useUserStore } from "@/stores/user";
import { onMounted } from "vue";
import UserstatItem from "../userstat/UserstatItem.vue";

const userstore = useUserStore();

onMounted(() => {
    if (userstore.loginUser.userid) {
        userstore.getUserstat(userstore.loginUser.userid);
    }
});
</script>

<style scoped>
h2 {
    font-weight: bold;
    color: #343a40;
}
.card {
    background-color: #f8f9fa;
}

.text-muted {
    color: #6c757d !important;
}

img.rounded-circle {
    border: 2px solid #ddd;
    padding: 5px;
    background: #fff;
}

h4 {
    font-weight: bold;
    color: #343a40;
}
</style>
