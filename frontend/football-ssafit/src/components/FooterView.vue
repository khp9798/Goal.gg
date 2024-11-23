<template>


    <footer class="footer mt-5" :class="userstore.isManagerMode ? 'gradient-effect-m' : 'gradient-effect-u'">
        <div class="col-md-4 d-flex align-items-center">
            <a href="/" class="mb-3 me-2 mb-md-0 text-body-secondary text-decoration-none lh-1">
                <svg class="bi" width="30" height="24">
                    <use xlink:href="#bootstrap"></use>
                </svg>
            </a>
            <span class="mb-3 mb-md-0 text-light">© 2024 GOAL.GG</span>
        </div>
    </footer>
</template>

<script setup>
import { useUserStore } from '@/stores/user';
import { onBeforeUpdate, watch } from 'vue';

const userstore =useUserStore();


</script>

<style scoped>
/* 기본 스타일 */
html,
body {
    margin: 0;
    padding: 0;
    height: 100%;
    /* 전체 페이지 높이 */
}

/* 전체 레이아웃 */
.layout {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    /* 뷰포트 전체 높이 */
}

/* 콘텐츠 영역 */
.content {
    flex: 1;
    /* 남는 공간을 채움 */
    padding: 20px;
    /* 기본 패딩 */
}

/* 푸터 스타일 */
.footer {
    /* 검은색 배경 */
    color: white;
    /* 흰색 텍스트 */
    padding: 1rem;
    text-align: center;
    width: 100%;
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