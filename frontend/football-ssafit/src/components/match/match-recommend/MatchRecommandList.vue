<template>
    <div class="container">
        <h2>추천 매치 목록</h2>
        <div class="scroll-wrapper">
            <!-- 좌우 스크롤 버튼 -->
            <button class="scroll-btn left" @click="scrollLeft">〈</button>
            <div ref="scrollContainer" class="scroll-container" @wheel.prevent="handleScroll">
                <!-- 스크롤 영역 -->
                <template v-if="store.RecommandMatchList.length > 0 && isAute">
                    <MatchRecommandListItem
                        v-for="match in store.RecommandMatchList"
                        :key="match.id"
                        :match="match"
                    />
                </template>
                <template v-else-if="store.RecommandMatchList.length <= 0 && isAute">
                    <h4>주변에 진행되는 매치가 없습니다...</h4>
                </template>
                <template v-else>
                    <MatchRecommandListItem
                        v-for="match in store.matchList"
                        :key="match.id"
                        :match="match"
                    />
                </template>
            </div>
            <button class="scroll-btn right" @click="scrollRight">〉</button>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUpdate } from 'vue';
import { useMatchStore } from '@/stores/match';
import MatchRecommandListItem from './MatchRecommandListItem.vue';
import { useUserStore } from '@/stores/user';

const store = useMatchStore();
const userstore = useUserStore();
const isAute = ref(false);

// 스크롤 컨테이너
const scrollContainer = ref(null);

// 스크롤 좌우 이동 메소드
const scrollLeft = () => {
    if (scrollContainer.value) {
        scrollContainer.value.scrollLeft -= 450; // 왼쪽으로 300px 이동
    }
};

const scrollRight = () => {
    if (scrollContainer.value) {
        scrollContainer.value.scrollLeft += 450; // 오른쪽으로 300px 이동
    }
};
const handleScroll = (event) => {
    if (scrollContainer.value) {
        scrollContainer.value.scrollLeft += event.deltaY *25; // 휠 이동량을 가로 스크롤로 변환
    }
};

onMounted(() => {
    if (!userstore.loginUser.userid) {
        isAute.value = false;
        store.getMatchList();
    } else {
        isAute.value = true;
        store.getRecommandMatchList(userstore.loginUser.district, userstore.loginUser.province);
    }
});
onBeforeUpdate(()=>{
    if (!userstore.loginUser.userid) {
        isAute.value = false;
        store.getMatchList();
    } else {
        isAute.value = true;
        store.getRecommandMatchList(userstore.loginUser.district, userstore.loginUser.province);
    }
})
</script>

<style scoped>
.container {
    position: relative;
    padding: 20px;
}

.scroll-wrapper {
    display: flex;
    align-items: center;
    position: relative;
}

.scroll-container {
    overflow-x: auto; /* 가로 스크롤 활성화 */
    white-space: nowrap; /* 자식 요소를 한 줄로 배치 */
    scroll-behavior: smooth; /* 부드러운 스크롤 */
    display: flex; /* 가로 방향 배치 */
    gap: 16px; /* 요소 간 간격 */
    width: calc(100% - 100px); /* 버튼 공간 제외 */
    margin: 0 auto;
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
    z-index: 10;

    &.left {
        margin-right: 5px;
    }

    &.right {
        margin-left: 5px;
    }
}

.scroll-btn:hover {
    background-color: rgba(0, 0, 0, 0.8);
}
</style>
