<template>
    <div>
        <h4>스탯 변화 추이</h4>
        <canvas id="myChart" width="600"></canvas>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import { Chart } from 'chart.js';
import { useStatStore } from '@/stores/stat';
import { useUserStore } from '@/stores/user';

const userStore = useUserStore();
const statstore = useStatStore();

const labels = ref([]);
const data = ref([]);
let chartInstance = null;

// 차트 생성 함수
const createChart = () => {
    const ctx = document.getElementById('myChart').getContext('2d');
    if (chartInstance) {
        chartInstance.destroy(); // 기존 차트가 있다면 제거
    }
    chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels.value,
            datasets: [
                {
                    label: '나의 스탯 변화',
                    data: data.value,
                    borderColor: 'rgba(75, 192, 192, 1)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderWidth: 2,
                    tension: 0,
                },
            ],
        },
        options: {
            responsive: false,
            scales: {
                y: {
                    beginAtZero: true,
                    min: 0,
                    max: 100,
                    ticks: {
                        stepSize: 10,
                    },
                },
            },
        },
    });
};

// 데이터 변경 감지
watch(
    () => statstore.userstatList,
    (newStatList) => {
        if (newStatList.length > 0) {
            labels.value = newStatList.map((item) => item["startTime"].slice(0, 10));
            data.value = newStatList.map((item) => {
                return (
                    (item.shoot + item.pass + item.speed + item.stamina + item.dribble) /
                    5
                );
            });
            createChart(); // 데이터 업데이트 후 차트 생성
        }
    },
    { immediate: true } // 데이터가 처음 로드될 때도 실행
);

// 데이터 로드
statstore.getStatList(userStore.loginUser.userid);
</script>

<style scoped>
canvas {
    max-width: 100%;
    margin: auto;
}
</style>
