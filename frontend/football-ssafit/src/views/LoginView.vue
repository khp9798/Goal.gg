<template>

    <section class="vh-100" style="margin: 0; padding: 0;">
        <div class="container h-100 p-0">
            <div class="row h-100 d-flex justify-content-center align-items-center">
                <div class="col col-xl-10">
                    <div class="card h-100" style="border-radius: 1rem; margin: 0;">
                        <div class="row g-0 h-100">
                            
                            <div class="col-md-6 col-lg-7 d-flex align-items-center">
                                <div class="card-body p-4 p-lg-5 text-black">

                                    <form @submit.prevent="tryLogin">

                                        <div class="d-flex align-items-center mb-3 pb-1">
                                            <img src="/src/assets/logo.png" alt="" width="100" class="bg-dark">
                                        </div>

                                        <h5 class="fw-normal mb-3 pb-3" style="letter-spacing: 1px;">Sign into your
                                            account</h5>

                                        <div data-mdb-input-init class="form-outline mb-4">
                                            <label class="form-label" for="form2Example17">ID</label>
                                            <input type="text" id="form2Example17" class="form-control form-control-lg"
                                                v-model="tryLoginUser.userid" />
                                        </div>

                                        <div data-mdb-input-init class="form-outline mb-4">
                                            <label class="form-label" for="form2Example27">Password</label>
                                            <input type="password" id="form2Example27"
                                                class="form-control form-control-lg" v-model="tryLoginUser.password" />
                                        </div>

                                        <div class="d-flex justify-content-even pt-1 mb-4">
                                            <button data-mdb-button-init data-mdb-ripple-init
                                                class="btn btn-dark btn-lg me-2" type="submit">Login</button>
                                            <button data-mdb-button-init data-mdb-ripple-init
                                                class="btn btn-dark btn-lg" type="button"
                                                @click="goSignupView">Register</button>
                                        </div>

                                    </form>

                                </div>
                            </div>
                            <div class="col-md-6 col-lg-5 d-none d-md-block">
                                <img src="https://cdn.spotvnews.co.kr/news/photo/202210/558962_781459_4446.jpg"
                                    alt="login form" class="img-fluid h-100"
                                    style="border-radius: 1rem 0 0 1rem; object-fit: cover;" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>



</template>

<script setup>
import { useUserStore } from '@/stores/user'; //유저 스토어 임포트
import { ref } from 'vue';
import router from '@/router';
const userstore = useUserStore() // 유저 스토어 사용
const tryLoginUser = ref({ // 입력된 로그인 정보
    userid: '',
    password: ''
})

function tryLogin() { // 로그인 시도
    userstore.tryLogin(tryLoginUser.value)
    tryLoginUser.value = {};
}


const goSignupView = function () {
    router.push({ name: 'signup' })
}

</script>

<style scoped>
.rounded-t-5 {
    border-top-left-radius: 0.5rem;
    border-top-right-radius: 0.5rem;
}

@media (min-width: 992px) {
    .rounded-tr-lg-0 {
        border-top-right-radius: 0;
    }

    .rounded-bl-lg-5 {
        border-bottom-left-radius: 0.5rem;
    }
}
</style>