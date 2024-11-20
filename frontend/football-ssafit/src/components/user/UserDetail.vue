<template>
    <div>
      <canvas id="myChart"></canvas>
    </div>
  </template>
  
  <script setup>
  import { onMounted } from 'vue';
  import { Chart } from 'chart.js';
  
  onMounted(() => {
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
            tension: 0.4, // 곡선의 부드러움
          },
        ],
      },
      options: {
        responsive: true, // 반응형 설정
        plugins: {
          legend: {
            position: 'top', // 범례 위치
          },
          tooltip: {
            enabled: true, // 툴팁 활성화
          },
        },
        scales: {
          x: {
            grid: {
              display: false, // X축 격자 숨기기
            },
          },
          y: {
            beginAtZero: true, // Y축 값 0부터 시작
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
  