<template>
    <div class="container mt-5">

        <h2 class="mb-4">유저 능력치</h2>

        <div class="card p-4 shadow d-flex" v-if="userstore.loginUser.userid">
            <div class="row row-cols-md-2">

                <!-- 유저 정보 -->
                <div class="col-md-2">
                    <h4>이름</h4>
                    <p>{{ userstore.loginUser.name }}</p>
                    <h4>포지션</h4>
                    <p>{{ userstore.loginUser.position }}</p>
                    <h4>티어</h4>
                    <img :src="`/src/assets/${userstore.loginUser.tier}.webp`" alt="" width="100" height="100">
                </div>


                <!-- 유저 능력치 차트 -->
                <div class="col-md-10">
                    <UserstatItem class="d-flex" />
                </div>

            </div>
        </div>


        <div class="card p-4 shadow" v-else>

            <div class="row row-cols-md-2">

                <!-- 유저 정보 -->
                <div class="col-md-2">
                    <h4>이름</h4>
                    <p>손흥민</p>
                    <h4>포지션</h4>
                    <p>forward</p>
                    <h4>티어</h4>
                    <img src="/src/assets/unranked.webp" alt="" width="100" height="100">
                </div>


                <!-- 유저 능력치 차트 -->
                <div class="col-md-10">
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
    console.log('마운트됏음')
    console.log(userstore.loginUser.userid)
    if (userstore.loginUser.userid) {
        userstore.getUserstat(userstore.loginUser.userid)
    }
})
</script>

<style scoped>
.card {
    background-color: #f8f9fa;
}
</style>