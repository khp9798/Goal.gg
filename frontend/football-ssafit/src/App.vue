<template>
  <div class="layout">
    <!-- 헤더 -->
    <HeaderNav />
    
    <!-- 라우터 뷰 -->
    <main class="content">
      <RouterView />
    </main>
    
    <!-- 푸터 -->
    <FooterView />

    
  </div>
</template>

<script setup>
import { RouterView } from "vue-router";
import HeaderNav from "./components/HeaderNav.vue";
import FooterView from "./components/FooterView.vue";
</script>

<style scoped>
/* 기본 스타일 */
html,
body {
  margin: 0;
  padding: 0;
  height: 100%; /* 뷰포트 전체 높이 */
}

/* 전체 레이아웃 설정 */
.layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh; /* 뷰포트 높이 */
}

/* 콘텐츠 영역 */
.content {
  flex: 1; /* 남는 공간을 채워 footer를 하단으로 밀어냄 */
}
</style>
