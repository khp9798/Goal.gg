<template>

    <header>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container-fluid">
                <!-- 로고 -->
                <RouterLink :to="{ name: 'home' }" class="navbar-brand">
                    <img src="../assets/logo.png" alt="Logo" width="40" height="40">
                </RouterLink>
                <!-- 메뉴 -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
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
                    <form class="d-flex" role="search">
                        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                        <button class="btn btn-outline-light" type="submit">Search</button>
                    </form>
                </div>
            </div>
        </nav>
    </header>

</template>

<script setup>
import { RouterLink } from 'vue-router/dist/vue-router';
import { useUserStore } from '@/stores/user';

const userstore = useUserStore();

function tryLogout() {
    userstore.tryLogout();
}
</script>

<style scoped>
/* RouterLink 기본 스타일 제거 */
.nav-link {
    text-decoration: none; /* 밑줄 제거 */
    color: white; /* 텍스트 색상 */
}

.nav-link:hover {
    color: #adb5bd; /* 호버 시 색상 */
}
</style>
