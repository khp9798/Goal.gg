<template>
    <header>
        <nav class="navbar navbar-expand-lg navbar-dark" :class="userstore.isManagerMode ? 'gradient-effect-m' : 'gradient-effect-u'">
            <div class="container-fluid">
                <!-- 로고 -->
                <RouterLink :to="{ name: 'home' }" class="navbar-brand d-flex align-items-center">
                    <img src="../assets/logo.png" alt="Logo" width="40" height="40" class="rounded-circle me-2">
                    <span class="fs-5 fw-bold">Goal.GG</span>
                </RouterLink>

                <!-- 토글 버튼 -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- 메뉴 -->
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <RouterLink :to="{ name: 'stadiumlist' }" class="nav-link" @click="getStadiumList">경기장
                            </RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink :to="{ name: 'userview' }" class="nav-link">유저 정보</RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink :to="{ name: 'match' }" class="nav-link">매치 일정</RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink :to="{ name: 'reservation' }" class="nav-link" @click="getReservationList">예약 확인
                            </RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink :to="{ name: 'matchregistform' }" class="nav-link" v-if="userstore.isManagerMode">매치 등록
                            </RouterLink>
                        </li>
                        <li class="nav-item">
                            <RouterLink :to="{ name: 'matchmanagerview' }" class="nav-link" v-if="userstore.isManagerMode">담당 매치
                            </RouterLink>
                        </li>
                    </ul>

                    <!-- 검색 폼 -->
                    <form class="d-flex me-3" @submit.prevent="handleSearch">
                        <select class="form-select form-select-sm bg-dark text-white border-secondary me-2"
                            v-model="condition.key">
                            <option value="name">이름</option>
                            <option value="address">주소</option>
                        </select>
                        <input type="search" class="form-control form-control-sm me-2" placeholder="찾고 싶은 구장을 입력하세요."
                            v-model="condition.word" />
                        <button class="btn btn-outline-light btn-sm" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </form>

                    <!-- 사용자 정보 -->
                    <div class="d-flex align-items-center">
                        <div v-if="userstore.loginUser.role === 'manager'" class="form-check form-switch me-3">
                            <input class="form-check-input" type="checkbox" id="managerModeSwitch"
                                v-model="userstore.isManagerMode">
                            <label class="form-check-label text-white" for="managerModeSwitch"><small>매니저
                                    모드</small></label>
                        </div>

                        <span class="text-light me-3" v-if="userstore.loginUser.name">{{ userstore.loginUser.name
                            }}</span>
                        <button v-if="userstore.loginUser.name" class="btn btn-outline-light btn-sm me-2"
                            @click="tryLogout">
                            로그아웃
                        </button>
                        <RouterLink v-else :to="{ name: 'loginview' }" class="btn btn-outline-light btn-sm">로그인
                        </RouterLink>
                    </div>
                </div>
            </div>
        </nav>
    </header>
</template>

<script setup>
import { RouterLink } from 'vue-router';
import { ref } from 'vue';
import { useUserStore } from '@/stores/user';
import { useStadiumStore } from '@/stores/stadium';
import { useReservationStore } from '@/stores/reservation';
import router from '@/router';

const userstore = useUserStore();
const stadiumstore = useStadiumStore();
const reservationstore = useReservationStore();

const condition = ref({
    key: "name",
    word: "",
});

const tryLogout = () => userstore.tryLogout();

const getStadiumList = () => stadiumstore.getStadiumList();

const getReservationList = () => {
    if (userstore.loginUser.userid) {
        reservationstore.getList(userstore.loginUser.userid);
    } else {
        alert("로그인이 필요합니다.");
        router.push({name:'loginview'})
    }
};

const handleSearch = () => {
    if (!condition.value.word.trim()) {
        alert("검색어를 입력해주세요.");
        return;
    }
    stadiumstore.searchList(condition.value);
};
</script>

<style scoped>
.navbar-brand img {
    width: 40px;
    height: 40px;
}

.nav-link {
    color: white;
}

.nav-link:hover {
    color: #adb5bd;
}

form .form-control {
    flex: 1;
    /* 남은 공간 차지 */
    min-width: 300px;
    /* 입력 필드 최소 너비 설정 */
}

form .form-select {
    background-color: #00000000;
    /* 검정색 배경 */
    color: white;
    /* 흰색 텍스트 */
    border-color: #ffffff;
    border-width: 1.5px;
    /* 테두리 색 */
}

form .form-select:focus {
    background-color: #21252900;
    /* 포커스 시 검정색 유지 */
    color: white;
    /* 포커스 시 텍스트 흰색 유지 */
    border-color: #ffffff;
    /* 포커스 시 테두리 색 */
}
.btn-outline-light:hover {
    background-color: white;
    color: black;
}

@keyframes gradient-m {
    0% {
        background: linear-gradient(90deg, #07782fe5, #212529);
    }
    50% {
        background: linear-gradient(90deg, #07782fe5, #343a40);
    }
    100% {
        background: linear-gradient(90deg, #07782fe5, #212529);
    }
}

.gradient-effect-m {
    animation: gradient-m 3600s ease-in-out infinite;
    background-size: 200% 200%;
}

@keyframes gradient-u {
    0% {
        background: linear-gradient(90deg, #000000, #212529);
    }
    50% {
        background: linear-gradient(90deg, #000000, #343a40);
    }
    100% {
        background: linear-gradient(90deg, #000000, #212529);
    }
}

.gradient-effect-u {
    animation: gradient-u 3600s ease-in-out infinite;
    background-size: 200% 200%;
}


</style>
