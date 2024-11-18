<template>
    <div class="bar-chart">
        <div v-for="(bar, index) in bars" :key="index" class="bar-container">
            <div class="bar" :style="{ height: bar.currentValue + '%', backgroundColor: black }"></div>
            <span>{{ bar.currentValue }}%</span>
        </div>
    </div>
</template>

<script>
import { ref, onMounted } from "vue";

export default {
    setup() {
        const bars = ref([
            { targetValue: 30, currentValue: 0 },
            { targetValue: 50, currentValue: 0 },
            { targetValue: 100, currentValue: 0 },
        ]);

        const animateBars = () => {
            bars.value.forEach((bar) => {
                const interval = setInterval(() => {
                    if (bar.currentValue < bar.targetValue) {
                        bar.currentValue++;
                        console.log(`Bar ${bar.targetValue}% updated: ${bar.currentValue}%`); // 디버깅
                    } else {
                        clearInterval(interval);
                    }
                }, 20);
            });
        };

        onMounted(() => {
            console.log("onMounted 실행됨"); // 디버깅용
            animateBars();
        });

        return {
            bars,
        };
    },
};
</script>

<style scoped>
.bar-chart {
  display: flex;
  gap: 20px;
  align-items: flex-end;
  height: 200px; /* 부모 컨테이너 높이 */
  margin: 20px;
}

.bar-container {
  text-align: center;
  width: 50px;
  height: 100%; /* 부모 컨테이너와 동일한 높이 */
  position: relative; /* 자식의 위치 기준 */
  border: 1px solid red; /* 디버깅용 */
}

.bar {
  width: 100%;
  background-color: yellow; /* 막대 배경색 */
  position: absolute; /* 부모 기준으로 위치 */
  bottom: 0; /* 막대가 아래에서부터 자라도록 설정 */
  transition: height 0.2s ease-out; /* 부드러운 애니메이션 */
}

</style>