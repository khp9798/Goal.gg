<template>
    <form @submit.prevent="registUserStat" class="user-stats-form">
        <div class="form-header">
            <h3>유저 아이디 : {{props.user.userId}}</h3>
        </div>
        <div class="form-group">
            <label>슛</label>
            <input type="number" v-model="userStats.shoot" min="0" max="100" class="input-field" />
        </div>
        <div class="form-group">
            <label>패스</label>
            <input type="number" v-model="userStats.pass" min="0" max="100" class="input-field" />
        </div>
        <div class="form-group">
            <label>속력</label>
            <input type="number" v-model="userStats.speed" min="0" max="100" class="input-field" />
        </div>
        <div class="form-group">
            <label>체력</label>
            <input type="number" v-model="userStats.stamina" min="0" max="100" class="input-field" />
        </div>
        <div class="form-group">
            <label>드리블</label>
            <input type="number" v-model="userStats.dribble" min="0" max="100" class="input-field" />
        </div>
        <button type="submit" class="submit-button" :disabled="isSubmitting"  >등록</button>
    </form>
</template>

<script setup>
import { useStatStore } from '@/stores/stat';
import { onMounted, ref } from 'vue';

const props = defineProps({
    user : Object
})

const userstatstore = useStatStore()

const userStats = ref({
    userId : props.user.userId,
    matchId : props.user.matchId,
    shoot: 0,
    pass: 0,
    speed: 0,
    stamina: 0,
    dribble: 0
})
const isSubmitting =ref(false)
const registUserStat = () => {
    console.log('Form submitted:', userStats);
    if (confirm("수정이 불가능합니다. 진행하시겠습니까?")) {
    // 확인 버튼을 누른 경우 실행할 코드
    console.log("진행을 선택하셨습니다.");
    userstatstore.registUserStat(userStats.value)
    isSubmitting.value = true;
} else {
    // 취소 버튼을 누른 경우 실행할 코드
    console.log("진행을 취소하셨습니다.");
}
}

onMounted(()=>{
    // Logic needed on mount
})
</script>

<style scoped>
.user-stats-form {
    max-width: 500px;
    margin: 50px auto;
    padding: 25px;
    border-radius: 10px;
    background-color: #e8f5e9;
    border: 1px solid #c8e6c9;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.form-header {
    text-align: center;
    margin-bottom: 20px;
    color: #2e7d32;
    font-weight: bold;
    font-size: 1.6rem;
}

.form-group {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 15px;
}

label {
    font-weight: 600;
    color: #1b5e20;
    font-size: 1rem;
    flex-basis: 30%;
}

.input-field {
    padding: 10px;
    border-radius: 5px;
    border: 1px solid #a5d6a7;
    flex-basis: 65%;
    transition: border-color 0.3s ease;
    font-size: 1rem;
}

.input-field:focus {
    border-color: #66bb6a;
    outline: none;
    box-shadow: 0 0 5px rgba(102, 187, 106, 0.5);
}

.submit-button {
    width: 100%;
    padding: 12px;
    background-color: #43a047;
    color: white;
    border: none;
    border-radius: 5px;
    font-size: 1.1rem;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
}

.submit-button:hover {
    background-color: #388e3c;
    transform: translateY(-2px);
}

.submit-button:active {
    transform: translateY(1px);
}
</style>
