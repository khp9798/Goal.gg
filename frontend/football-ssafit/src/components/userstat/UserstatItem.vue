<template>
    <div>
        <canvas id="radarChart"></canvas>
    </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { Chart, registerables } from "chart.js";
import { useStatStore } from "@/stores/stat";
import { useUserStore } from "@/stores/user";

Chart.register(...registerables);

const store = useStatStore();
const userStore = useUserStore();
const data = ref([]);

onMounted(async () => {
    // 데이터 로드
    await store.getStat(userStore.loginUser.userid);
    data.value = Object.values(store.userstatavg);

    // 차트 생성
    const ctx = document.getElementById("radarChart").getContext("2d");
    new Chart(ctx, {
        type: "radar",
        data: {
            labels: ["Pass", "Stamina", "Dribble", "Shoot", "Speed"],
            datasets: [
                {
                    label: "User Stats",
                    data: data.value,
                    backgroundColor: "rgba(0, 128, 255, 0.4)",
                    borderColor: "blue",
                    pointBackgroundColor: "red",
                },
            ],
        },
        options: {
            animation: {
                duration: 1000, // 애니메이션 지속 시간 (ms)
                easing: "easeOutBounce", // 애니메이션 종류
                onProgress: (animation) => {
                    // console.log(`진행률: ${animation.currentStep}/${animation.numSteps}`);
                },
            },
            responsive: true, // 부모 크기에 따라 자동 조정
            maintainAspectRatio: false, // 비율 유지하지 않음
            scales: {
                r: {
                    angleLines: { display: true },
                    suggestedMin: 0,
                    suggestedMax: 100,
                },
            },
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
