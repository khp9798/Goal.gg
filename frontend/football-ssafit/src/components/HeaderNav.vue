<template>
    <header>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container-fluid">
                <!-- 로고 -->
                <RouterLink :to="{ name: 'home' }" class="navbar-brand">
                    <img src="../assets/logo.png" alt="Logo" width="50" height="50">
                </RouterLink>

                <!-- 메뉴 -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <!-- 왼쪽 메뉴 -->
                    <ul class="navbar-nav me-auto mb-2">
                        <li class="nav-item me-3">
                            <RouterLink :to="{ name: 'stadiumlist' }" class="nav-link" @click="getStadiumList">경기장
                            </RouterLink>
                        </li>
                        <li class="nav-item me-3">
                            <RouterLink :to="{ name: 'userview' }" class="nav-link">유저 정보</RouterLink>
                        </li>
                        <li class="nav-item me-3">
                            <RouterLink :to="{ name: 'match' }" class="nav-link">매치 일정</RouterLink>
                        </li>
                        <li class="nav-item me-3">
                            <RouterLink :to="{ name: 'reservation' }" class="nav-link" @click="getReservationList">예약 확인
                            </RouterLink>
                        </li>
                    </ul>

                    <!-- 검색 폼 -->
                    <!-- 검색 폼 -->
                    <form class="d-flex align-items-center gap-3 me-3" role="search" @submit.prevent="handleSearch">
                        <select class="form-select" v-model="condition.key" id="floatingSelect">
                            <option value="name">이름</option>
                            <option value="address">주소</option>
                        </select>
                        <input id="searchField" class="form-control" type="search" placeholder="찾고 싶은 구장을 입력하세요."
                            aria-label="Search" v-model="condition.word" />
                        <!-- 돋보기 아이콘 버튼 -->
                        <button class="btn btn-outline-light" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </form>



                    <!-- 사용자 정보 섹션 -->
                    <div class="d-flex align-items-center">
                        <div v-if="userstore.loginUser.role === 'manager'" class="form-check form-switch me-3">
                            <input class="form-check-input" type="checkbox" id="flexSwitchCheckDefault" v-model="userstore.isManagerMode">
                            <label class="form-check-label" for="flexSwitchCheckDefault"><small>매니저모드</small></label>
                        </div>
                        <span class="nav-link me-3" v-if="userstore.loginUser.name">{{ userstore.loginUser.name
                            }}</span>
                        <button class="btn btn-outline-light btn-sm" v-if="userstore.loginUser.name"
                            @click="tryLogout">로그아웃</button>
                        <RouterLink :to="{ name: 'loginview' }" class="btn btn-outline-light btn-sm"
                            v-if="!userstore.loginUser.name">로그인</RouterLink>
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
import { useStadiumStore } from '@/stores/stadium';
import { useReservationStore } from '@/stores/reservation';
import router from '@/router';
const reservationstore = useReservationStore()

const userstore = useUserStore();

function tryLogout() {
    userstore.tryLogout();
}

const getReservationList = function () {
    if (userstore.loginUser.userid) {
        console.log(userstore.loginUser.userid)
        reservationstore.getList(userstore.loginUser.userid)
    } else {
        alert("로그인이 필요합니다")
        router.push({ name: 'loginview' })
    }
}

const condition = ref({
    key: "name",
    word: "",
    order: "",
    orderDir: ""
})

const getStadiumList = function () {
    stadiumstore.getStadiumList()
}
const stadiumstore = useStadiumStore()
const search = function () {
    stadiumstore.searchList(condition.value)
}


const handleSearch = () => {
    // 입력 값 확인

    if (!condition.value.word || condition.value.word.trim() === "") {
        alert("검색어를 입력해주세요."); // 검색어가 없으면 알림 표시
        return;
    }

    // 정상적인 검색 실행
    stadiumstore.searchList(condition.value);
};



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

form .form-control {
    flex: 1;
    /* 남은 공간 차지 */
    min-width: 300px;
    /* 입력 필드 최소 너비 설정 */
}

form .form-select {
    background-color: #212529;
    /* 검정색 배경 */
    color: white;
    /* 흰색 텍스트 */
    border-color: #495057;
    /* 테두리 색 */
}

form .form-select:focus {
    background-color: #212529;
    /* 포커스 시 검정색 유지 */
    color: white;
    /* 포커스 시 텍스트 흰색 유지 */
    border-color: #6c757d;
    /* 포커스 시 테두리 색 */
    box-shadow: none;
    /* 포커스 시 그림자 제거 */
}

.form-check {
    display: inline-flex;
    align-items: center;
    /* 수직 중앙 정렬 */
}

.form-check-input {
    margin-top: 0;
    /* 기본적으로 위로 떠 있는 여백 제거 */
}

.form-check-label {
    color: white !important;
    /* 텍스트를 흰색으로 변경 */
}
</style>
