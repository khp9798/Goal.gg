<template>
    <div class="container mt-5">
        <h2 class="mb-4">추천 매치 목록</h2>

        <div class="scroll-wrapper position-relative">
            <!-- 좌우 스크롤 버튼 -->
            <button class="scroll-btn left" @click="scrollLeft">〈</button>
            <div ref="scrollContainer" class="scroll-container shadow-sm rounded">
                <!-- 스크롤 영역 -->
                <template v-if="store.RecommandMatchList.length > 0 && userstore.isAuth">
                    <MatchRecommandListItem v-for="match in store.RecommandMatchList" :key="match.id" :match="match" />
                </template>
                <template v-else-if="store.RecommandMatchList.length <= 0 && userstore.isAuth">
                    <div class="empty-message text-center">
                        <h4>주변에 진행되는 매치가 없습니다...</h4>
                    </div>
                </template>
                <template v-else>
                    <MatchRecommandListItem v-for="match in store.RecommandMatchList" :key="match.id" :match="match" />
                </template>
            </div>
            <button class="scroll-btn right" @click="scrollRight">〉</button>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import { useMatchStore } from "@/stores/match";
import MatchRecommandListItem from "./MatchRecommandListItem.vue";
import { useUserStore } from "@/stores/user";

const store = useMatchStore();
const userstore = useUserStore();

// 스크롤 컨테이너
const scrollContainer = ref(null);

// 스크롤 좌우 이동 메소드
const scrollLeft = () => {
    if (scrollContainer.value) {
        scrollContainer.value.scrollLeft -= 450; // 왼쪽으로 450px 이동
    }
};

const scrollRight = () => {
    if (scrollContainer.value) {
        scrollContainer.value.scrollLeft += 450; // 오른쪽으로 450px 이동
    }
};

// 유저 정보 감지 및 추천 매치 목록 업데이트
watch(
    () => userstore.loginUser,
    () => {
        if (!userstore.loginUser.district || !userstore.loginUser.province) {
            store.getRecommandMatchList("", "");
        } else {
            store.getRecommandMatchList(
                userstore.loginUser.district,
                userstore.loginUser.province
            );
        }
    },
    { deep: true }
);

onMounted(() => {
    if (!userstore.loginUser.district || !userstore.loginUser.province) {
        store.getRecommandMatchList("", "");
    } else {
        store.getRecommandMatchList(
            userstore.loginUser.district,
            userstore.loginUser.province
        );
    }
});
</script>

<style scoped>
h2 {
    font-weight: bold;
    color: #343a40;
}
/* 컨테이너 스타일 */
.container {
    padding: 20px;
}

/* 스크롤 영역 */
.scroll-wrapper {
    display: flex;
    align-items: center;
    position: relative;
}

.scroll-container {
    overflow-x: auto;
    white-space: nowrap;
    scroll-behavior: smooth;
    display: flex;
    gap: 16px;
    width: calc(100% - 100px);
    margin: 0 auto;
    background-color: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
}

/* 빈 결과 메시지 */
.empty-message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 150px;
    color: #6c757d;
}

/* 좌우 스크롤 버튼 */
.scroll-btn {
    position: relative;
    background-color: rgba(0, 0, 0, 0.5);
    color: white;
    border: none;
    padding: 10px 15px;
    font-size: 18px;
    cursor: pointer;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 10;
}

.scroll-btn.left {
    margin-right: 5px;
}

.scroll-btn.right {
    margin-left: 5px;
}

.scroll-btn:hover {
    background-color: rgba(0, 0, 0, 0.8);
}

/* 카드 요소 통일 스타일 */
.MatchRecommandListItem {
    flex: 0 0 auto;
    width: 250px;
    height: 350px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    background: white;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
}

.MatchRecommandListItem:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
}
</style>
