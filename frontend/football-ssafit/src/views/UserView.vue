<template>
    <div class="container mt-5">
        <!-- 페이지 제목 -->
        <h2 class="pb-3 border-bottom text-center">마이페이지</h2>

        <!-- 유저 정보 및 통계 -->
        <div v-if="userstore.loginUser.userid" class="text-center">
            <!-- 나와 비슷한 선수 -->
            <div class="card p-4 shadow mb-4">
                <h4 class="mb-3">나와 비슷한 선수</h4>
                <UserstatItem />
            </div>

            <!-- 유저 스탯 차트 -->
            <div class="card p-4 shadow mb-4">
                <h4 class="mb-3">내 스탯 통계</h4>
                <UserstatChart />
            </div>

            
        </div>
    </div>
</template>

<script setup>
import UserstatChart from "@/components/userstat/UserstatChart.vue";
import UserstatItem from "@/components/userstat/UserstatItem.vue";
import router from "@/router";
import { useUserStore } from "@/stores/user";
import { onBeforeMount } from "vue";

// 유저 스토어
const userstore = useUserStore();

// 로그인 확인
onBeforeMount(() => {
    if (!userstore.loginUser.userid) {
        window.alert("로그인이 필요합니다.");
        router.push({ name: "loginview" });
    }
});
</script>

<style scoped>
/* 카드 스타일 */
.card {
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    background-color: #ffffff;
}

.card h4 {
    font-weight: bold;
    color: #333;
}

/* 페이지 제목 스타일 */
h2 {
    font-weight: bold;
    color: #444;
}

/* 반응형 스타일 */
@media (max-width: 768px) {
    .card {
        padding: 2rem;
    }

    h2 {
        font-size: 1.5rem;
    }

    h4 {
        font-size: 1.2rem;
    }
}
</style>
