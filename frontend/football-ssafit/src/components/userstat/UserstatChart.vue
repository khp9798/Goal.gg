<template>
    <div>
        <h4>스탯 변화 추이</h4>
        <canvas ref="chartCanvas" width="600px"></canvas>
    </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue';
import { Chart } from 'chart.js';
import { useStatStore } from '@/stores/stat';
import { useUserStore } from '@/stores/user';

// Store 접근
const userStore = useUserStore();
const statstore = useStatStore();

// 데이터 및 Chart.js 관련 변수
const labels = ref([]);
const data = ref([]);
const chartCanvas = ref(null); // canvas 요소를 참조할 ref
let chartInstance = null; // Chart.js 인스턴스

// 차트 생성 또는 업데이트 함수
const createOrUpdateChart = () => {
    if (chartInstance) {
        // 기존 차트가 있으면 업데이트
        chartInstance.data.labels = labels.value;
        chartInstance.data.datasets[0].data = data.value;
        chartInstance.update();
    } else if (chartCanvas.value) {
        // 새로운 차트 생성
        const ctx = chartCanvas.value.getContext('2d');
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
    }
};

// 데이터 변경 감지 및 초기화
watch(
    () => statstore.userstatList,
    (newStatList) => {
        if (newStatList.length > 0) {
            // 데이터 갱신
            labels.value = newStatList.map((item) =>
                item["startTime"] ? item["startTime"].slice(0, 10) : ''
            );
            data.value = newStatList.map((item) => {
                return (
                    (item.shoot + item.pass + item.speed + item.stamina + item.dribble) /
                    5
                );
            });
            createOrUpdateChart(); // 차트 갱신
        }
    },
    { immediate: true } // 처음 로드 시에도 실행
);

// 데이터 로드
onMounted(() => {
    statstore.getStatList(userStore.loginUser.userid);
});
</script>

<style scoped>
canvas {
    max-width: 100%;
    margin: auto;
}
</style>
