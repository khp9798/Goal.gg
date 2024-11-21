<template>
    <div>
        <canvas id="myChart"></canvas>
        <p>{{ statstore.userstatList }}</p>
        <p>{{ labels }}</p>
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { Chart } from 'chart.js';
import { useStatStore } from '@/stores/stat';
import { useUserStore } from '@/stores/user';

const userStore = useUserStore()

const statstore = useStatStore()


const labels = ref([])
onMounted(() => {
    statstore.getStatList(userStore.loginUser.userid)


    labels.value = Object.keys(statstore.userstatList)
    .filter(key => key === "createdAt")
    .map(key => statstore.userstatList[key]);


    const ctx = document.getElementById('myChart').getContext('2d');
    new Chart(ctx, {
        type: 'line', // 그래프 타입: 라인 그래프
        data: {
            labels: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'], // X축 레이블
            datasets: [
                {
                    label: 'Weekly Sales', // 데이터 세트 이름
                    data: [14000, 16000, 22000, 18000, 20000, 24000, 12000], // Y축 값
                    borderColor: 'rgba(75, 192, 192, 1)', // 선 색상
                    backgroundColor: 'rgba(75, 192, 192, 0.2)', // 배경 색상
                    borderWidth: 2, // 선 두께
                    tension: 0, // 곡선의 부드러움

                },
            ],
        },

    });
});
</script>

<style scoped>
canvas {
    max-width: 100%;
    margin: auto;
}
</style>