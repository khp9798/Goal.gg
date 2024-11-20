<template>

    <header>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container-fluid">
                <!-- 로고 -->
                <RouterLink :to="{ name: 'home' }" class="navbar-brand">
                    <img src="../assets/logo.png" alt="Logo" width="40" height="40">
                </RouterLink>
                <!-- 메뉴 -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto mb-2">
                        <li class="nav-item me-3"> <!-- 간격 추가 -->
                            <RouterLink :to="{ name: 'stadiumlist' }" class="nav-link">경기장</RouterLink>
                        </li>
                        <li class="nav-item me-3"> <!-- 간격 추가 -->
                            <RouterLink :to="{ name: 'userview' }" class="nav-link">유저 정보</RouterLink>
                        </li>
                        <li class="nav-item me-3"> <!-- 간격 추가 -->
                            <RouterLink :to="{ name: 'match' }" class="nav-link">매치 일정</RouterLink>
                        </li>
                        <li class="nav-item me-3"> <!-- 간격 추가 -->
                            <RouterLink :to="{ name: 'reservation' }" class="nav-link">예약 확인</RouterLink>
                        </li>
                    </ul>
                    <!-- 검색 폼 -->


                    <div class="navbar-nav me-auto mb-2">
                        <form class="d-flex" role="search" @submit.prevent="search">
                            <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" v-model="condition.word">
                            <button class="btn btn-outline-light" type="submit">Search</button>
                        </form>
                        <RouterLink :to="{name : 'loginview'}" class="nav-link d-flex" v-if="!userstore.loginUser.name">로그인</RouterLink>
                        <a class="nav-link d-flex" v-if="userstore.loginUser.name">{{userstore.loginUser.name}}님 반갑습니다</a>
                        <a class="nav-link d-flex" v-if="userstore.loginUser.name" @click="tryLogout">로그아웃</a>
                    </div>
                </div>
            </div>
        </nav>
    </header>

</template>

<script setup>
import { RouterLink } from 'vue-router/dist/vue-router';
import { useUserStore } from '@/stores/user';
import { useMatchStore } from '@/stores/match';
import { ref } from 'vue';

const userstore = useUserStore();

function tryLogout() {
    userstore.tryLogout();
}

const condition = ref({
    key : "",
    word : "",
    order : "",
    orderDir : ""
})
const matchStore = useMatchStore()
const search = function(){
    matchStore.search(condition.value)
}


</script>

<style scoped>
/* RouterLink 기본 스타일 제거 */
.nav-link {
    text-decoration: none;
    /* 밑줄 제거 */
    color: white;
}

.nav-link:hover {
    color: #adb5bd;
    /* 호버 시 색상 */
}
</style>
