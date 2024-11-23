<template>
    <footer class="footer mt-5" :class="userstore.isManagerMode ? 'gradient-effect-m' : 'gradient-effect-u'">
        <div class="col-md-4 d-flex align-items-center">
            <a href="/" class="mb-3 me-2 mb-md-0 text-body-secondary text-decoration-none lh-1">
                <svg class="bi" width="30" height="24">
                    <use xlink:href="#bootstrap"></use>
                </svg>
            </a>
            <!-- 저작권 -->
            <span class="text-light">© 2024 GOAL.GG</span>
        </div>
    </footer>
</template>

<script setup>
import { useUserStore } from '@/stores/user';
import { onBeforeUpdate, watch } from 'vue';

const userstore =useUserStore();


</script>

<style scoped>
.footer {
    /* 푸터 고정 스타일 */
    position: relative;
    bottom: 0;
    width: 100%;
    text-align: center;
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
