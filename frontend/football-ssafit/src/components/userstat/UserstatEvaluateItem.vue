<template>
    <form @submit.prevent="registUserStat" class="user-stats-form">
        <div class="form-header">
            <h3>유저 아이디: {{ props.user.userId }}</h3>
        </div>
        <div class="form-group" v-for="(label, key) in statLabels" :key="key">
            <div class="stat-container">
                <div class="stat-label">{{ label }}</div>
                <div class="stat-values">
                    <div>
                        <span class="value-label">기존 능력치:</span>
                        <span class="value">{{ props.user[key] }}</span>
                    </div>
                    <div>
                        <span class="value-label">새로운 능력치:</span>
                        <input
                            type="number"
                            v-model="userStats[key]"
                            min="0"
                            max="100"
                            class="input-field"
                        />
                    </div>
                </div>
            </div>
        </div>
        <button
            type="submit"
            :class="`${isSubmitting ? 'submit-button2' : 'submit-button'}`"
            :disabled="isSubmitting"
        >
            등록
        </button>
    </form>
</template>

<script setup>
import { useReservationStore } from '@/stores/reservation';
import { useStatStore } from '@/stores/stat';
import { onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';

const props = defineProps({
    user: Object,
});
const route = useRoute()

const userstatstore = useStatStore();

const statLabels = {
    shoot: '슛',
    pass: '패스',
    speed: '속력',
    stamina: '체력',
    dribble: '드리블',
};

const userStats = ref({
    userId: props.user.userId,
    matchId: route.params.id,
    shoot: 0,
    pass: 0,
    speed: 0,
    stamina: 0,
    dribble: 0,
});

const isSubmitting = ref(false);

const registUserStat = () => {
    console.log('Form submitted:', userStats);
    if (confirm('수정이 불가능합니다. 진행하시겠습니까?')) {
        console.log('진행을 선택하셨습니다.');
        userstatstore.registUserStat(userStats.value);
        isSubmitting.value = true;
    } else {
        console.log('진행을 취소하셨습니다.');
    }
};

onMounted(() => {
    // Logic needed on mount
});
</script>

<style scoped>
.user-stats-form {
    max-width: 600px;
    margin: 50px auto;
    padding: 25px;
    border-radius: 15px;
    background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
    box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
    font-family: 'Roboto', sans-serif;
}

.form-header {
    text-align: center;
    margin-bottom: 30px;
    font-size: 1.8rem;
    color: #2e7d32; /* 초록색 */
    font-weight: bold;
}

.form-group {
    margin-bottom: 20px;
}

.stat-container {
    display: flex;
    flex-direction: column;
    margin-bottom: 15px;
    background: #ffffff;
    border: 1px solid #c5e1a5; /* 연한 초록색 */
    border-radius: 8px;
    padding: 15px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.stat-label {
    font-size: 1.2rem;
    font-weight: bold;
    color: #1b5e20; /* 진한 초록색 */
    margin-bottom: 10px;
}

.stat-values {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.value-label {
    font-size: 0.9rem;
    color: #558b2f; /* 중간 초록색 */
    margin-right: 10px;
}

.value {
    font-size: 1rem;
    color: #33691e; /* 진한 초록색 */
    margin-right: 15px;
    font-weight: bold;
}

.input-field {
    width: 60px;
    padding: 5px;
    border-radius: 5px;
    border: 1px solid #a5d6a7; /* 초록 테두리 */
    text-align: center;
    transition: border-color 0.3s ease;
    font-size: 1rem;
}

.input-field:focus {
    border-color: #66bb6a; /* 초록색 강조 */
    outline: none;
    box-shadow: 0 0 5px rgba(102, 187, 106, 0.5);
}

.submit-button {
    width: 100%;
    padding: 12px;
    background-color: #43a047; /* 진한 초록색 */
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 1.2rem;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
}

.submit-button:hover {
    background-color: #388e3c; /* 더 진한 초록색 */
    transform: translateY(-2px);
}

.submit-button:active {
    transform: translateY(1px);
}

.submit-button2 {
    width: 100%;
    padding: 12px;
    background-color: #6f6f6f; /* 진한 초록색 */
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 1.2rem;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
    cursor: not-allowed;
}
</style>

