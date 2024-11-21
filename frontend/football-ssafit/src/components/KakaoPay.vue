<template>
  <div>
    <h1>카카오페이 결제</h1>
    <button @click="initiatePayment">결제하기</button>
  </div>
</template>

<script setup>
import axios from "axios";

const initiatePayment = async () => {
  try {
    const response = await axios.post("http://localhost:8080/order/pay/ready", {
      name: "테스트 상품",
      totalPrice: "5000",
    });

    // 결제 페이지로 리다이렉트
    if (response.data.next_redirect_pc_url) {
      window.location.href = response.data.next_redirect_pc_url;
    }
  } catch (error) {
    console.error("결제 요청 실패:", error);
  }
};
</script>

<style scoped>
/* 스타일을 여기에 추가하세요 */
</style>
