<template>
    <section class="vh-100 bg-light" style="margin: 0; padding: 0;">
        <div class="container h-100">
            <div class="row h-100 d-flex justify-content-center align-items-center">
                <div class="col col-xl-10">
                    <div class="card shadow-lg" style="border-radius: 1rem;">
                        <div class="row g-0 h-100">

                            <!-- 이미지 영역 -->
                            <div class="col-md-6 col-lg-5 d-none d-md-block">
                                <img src="/src/assets/loginSon.jpg"
                                    alt="login form" class="img-fluid h-100 rounded-start" style="object-fit: cover;" />
                            </div>

                            <!-- 로그인 폼 영역 -->
                            <div class="col-md-6 col-lg-7 d-flex align-items-center">
                                <div class="card-body p-5 text-black">

                                    <form @submit.prevent="tryLogin">
                                        <!-- 로고 -->
                                        <div class="d-flex align-items-center justify-content-center mb-4">
                                            <img src="/src/assets/logo.png" alt="Logo" width="80"
                                                class="rounded-circle bg-dark p-2">
                                        </div>

                                        <!-- 제목 -->
                                        <h5 class="fw-bold text-center mb-4" style="letter-spacing: 1px;">로그인</h5>

                                        <!-- ID 입력 -->
                                        <div class="form-outline mb-4">
                                            <label class="form-label" for="form2Example17">아이디</label>
                                            <input type="text" id="form2Example17" class="form-control form-control-lg"
                                                v-model="tryLoginUser.userid" placeholder="아이디를 입력하세요" />
                                        </div>

                                        <!-- 비밀번호 입력 -->
                                        <div class="form-outline mb-4">
                                            <label class="form-label" for="form2Example27">비밀번호</label>
                                            <input type="password" id="form2Example27"
                                                class="form-control form-control-lg" v-model="tryLoginUser.password"
                                                placeholder="비밀번호를 입력하세요" />
                                        </div>

                                        <!-- 버튼 -->
                                        <div class="d-flex justify-content-between pt-1 mb-4">
                                            <button class="btn btn-dark btn-lg me-2 w-50" type="submit">
                                                로그인
                                            </button>
                                            <button class="btn btn-outline-dark btn-lg w-50" type="button"
                                                @click="goSignupView">
                                                회원가입
                                            </button>
                                        </div>
                                    </form>

                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import { useUserStore } from '@/stores/user';
import { ref } from 'vue';
import router from '@/router';

const userstore = useUserStore(); // 유저 스토어 사용
const tryLoginUser = ref({
    userid: '',
    password: '',
});

function tryLogin() {
    userstore.tryLogin(tryLoginUser.value);
    tryLoginUser.value = { userid: '', password: '' };
}

function goSignupView() {
    router.push({ name: 'signup' });
}
</script>

<style scoped>
/* 카드 그림자와 반응형 스타일 */
.card {
    border-radius: 1rem;
    background-color: #fff;
    border: none;
    overflow: hidden;
}

.img-fluid {
    border-top-left-radius: 1rem;
    border-bottom-left-radius: 1rem;
}

@media (max-width: 768px) {
    .img-fluid {
        border-top-left-radius: 0;
        border-bottom-left-radius: 0;
    }
}

h5 {
    color: #333;
}

.form-control {
    border: 1px solid #ddd;
    border-radius: 0.5rem;
}

.form-control:focus {
    box-shadow: none;
    border-color: #333;
}

.btn {
    transition: background-color 0.3s ease, color 0.3s ease;
}

.btn:hover {
    background-color: #444;
    color: #fff;
}

.btn-outline-dark {
    border: 1px solid #444;
    background-color: #fff;
    color: #444;
}

.btn-outline-dark:hover {
    background-color: #444;
    color: #fff;
}
</style>
