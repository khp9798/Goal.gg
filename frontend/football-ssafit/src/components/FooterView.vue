<template>
    <footer class="footer mt-5 py-3" :class="userstore.isManagerMode ? 'gradient-effect-m' : 'gradient-effect-u'">
        <div class="container d-flex justify-content-between align-items-center">
            <!-- 로고 섹션 -->
            <div class="d-flex align-items-center">
                <a href="/" class="text-decoration-none d-flex align-items-center">
                    <img src="/src/assets/logo.png" alt="Goal.gg Logo" class="footer-logo me-2" />
                    <span class="text-light fw-bold">GOAL.GG</span>
                </a>
            </div>

            <!-- 이용약관 및 개인정보 처리방침 -->
            <div class="d-flex gap-3">
                <a href="/terms" class="text-light text-decoration-none">이용약관</a>
                <a href="/privacy" class="text-light text-decoration-none">개인정보 처리방침</a>
            </div>

            <!-- 저작권 -->
            <div>
                <span class="text-light">© 2024 GOAL.GG</span>
            </div>
        </div>
    </footer>
</template>

<script setup>
import { useUserStore } from "@/stores/user";

const userstore = useUserStore();
</script>

<style scoped>
.footer {
    /* 푸터 고정 및 스타일 */
    width: 100%;
    text-align: center;
    background-color: #212529;
}

/* 로고 크기 */
.footer-logo {
    width: 50px;
    height: auto;
}

/* 링크 스타일 */
a {
    font-size: 0.9rem;
}

/* gradient-m 애니메이션 */
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

/* gradient-u 애니메이션 */
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
