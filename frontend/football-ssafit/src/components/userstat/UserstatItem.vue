<template>
    <div>

        <div class="row row-cols-md-2 g-4 text-center">
            <div>
                <canvas ref="radarChart"></canvas>
            </div>
            <div>
                <img :src="`/src/assets/PlayerImg/${store.myKLeaguer.playercode}.png`" alt="Player Image"/>
                <p>{{ store.myKLeaguer.name }}</p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { Chart, registerables } from "chart.js";
import { useStatStore } from "@/stores/stat";
import { useUserStore } from "@/stores/user";

// Chart.js 플러그인 등록
Chart.register(...registerables);

const store = useStatStore();
const userStore = useUserStore();
const data = ref([]);
const targetdata = ref([]);

// `canvas`를 참조할 ref
const radarChart = ref(null);

const keys = ["pass", "stamina", "dribble", "shoot", "speed"];

onMounted(async () => {
    // 데이터 로드
    if (store.myKLeaguer.value == undefined || store.userstatavg.value == undefined) {
        console.log("hi")
        await store.getMyLeague(userStore.loginUser.userid);
        await store.getStat(userStore.loginUser.userid);
    }



    data.value = Object.values(store.userstatavg);
    targetdata.value = Object.keys(store.myKLeaguer)
        .filter(key => keys.includes(key)) // keys에 포함된 key만 필터링
        .map(key => store.myKLeaguer[key]); // 해당 key의 value를 가져옴

    // `radarChart` ref를 통해 DOM에 접근
    if (radarChart.value) {
        const ctx = radarChart.value.getContext("2d");
        new Chart(ctx, {
            type: "radar",
            data: {
                labels: ["Pass", "Stamina", "Dribble", "Shoot", "Speed"],
                datasets: [
                    {
                        label: "User Stats",
                        data: data.value,
                        backgroundColor: "rgba(0, 128, 255, 0.4)",
                        pointBackgroundColor: "red",
                    },
                    {
                        label: store.myKLeaguer.name + " Stats",
                        data: targetdata.value,
                        backgroundColor: "rgba(128,0,0, 0.4)",
                        pointBackgroundColor: "red",
                    },
                ],
            },
            options: {
                animation: {
                    duration: 1000,
                    easing: "easeOutBounce",
                },
                responsive: false,
                scales: {
                    r: {
                        angleLines: { display: true },
                        suggestedMin: 0,
                        suggestedMax: 100,
                    },
                },
            },
        });
    }
});
</script>

<style scoped>
canvas {
    max-width: 100%;
    margin: auto;
}
</style>
