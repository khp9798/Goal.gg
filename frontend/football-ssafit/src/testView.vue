<template>
    <div>
      <canvas ref="canvas" width="400" height="400" style="border: 1px solid black;"></canvas>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from "vue";
  
  export default {
    setup() {
      const canvas = ref(null);
  
      // 오각형을 그리는 함수
      const drawPentagon = (ctx, centerX, centerY, radius, values) => {
        const totalSides = 5; // 오각형
        const angleStep = (2 * Math.PI) / totalSides;
  
        // 배경 오각형 그리기
        ctx.clearRect(0, 0, 400, 400); // Canvas 초기화
        ctx.beginPath();
        for (let i = 0; i < totalSides; i++) {
          const x = centerX + radius * Math.cos(i * angleStep);
          const y = centerY + radius * Math.sin(i * angleStep);
          i === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
        }
        ctx.closePath();
        ctx.strokeStyle = "gray";
        ctx.stroke();
  
        // 값에 따른 오각형 그리기
        ctx.beginPath();
        for (let i = 0; i < totalSides; i++) {
          const x = centerX + radius * values[i] * Math.cos(i * angleStep);
          const y = centerY + radius * values[i] * Math.sin(i * angleStep);
          i === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
        }
        ctx.closePath();
        ctx.fillStyle = "rgba(0, 123, 255, 0.5)";
        ctx.fill();
      };
  
      // Canvas에 그래프를 애니메이션으로 그리기
      const animateGraph = () => {
        const ctx = canvas.value.getContext("2d");
        const centerX = 200;
        const centerY = 200;
        const radius = 100;
  
        // 초기 값 설정 (0부터 시작)
        const targetValues = [0.8, 0.6, 0.9, 0.7, 1.0]; // 목표 값
        const currentValues = [0, 0, 0, 0, 0]; // 초기 값
  
        const interval = setInterval(() => {
          let completed = true;
  
          for (let i = 0; i < targetValues.length; i++) {
            if (currentValues[i] < targetValues[i]) {
              currentValues[i] += 0.02; // 점진적으로 증가
              if (currentValues[i] > targetValues[i]) {
                currentValues[i] = targetValues[i];
              }
              completed = false; // 아직 애니메이션이 진행 중임
            }
          }
  
          // 그래프를 다시 그리기
          drawPentagon(ctx, centerX, centerY, radius, currentValues);
  
          // 모든 값이 목표에 도달하면 애니메이션 종료
          if (completed) {
            clearInterval(interval);
          }
        }, 30); // 애니메이션 속도
      };
  
      onMounted(() => {
        animateGraph();
      });
  
      return { canvas };
    },
  };
  </script>
  
<style scoped>
canvas {
  display: block;
  margin: 20px auto;
}
</style>
