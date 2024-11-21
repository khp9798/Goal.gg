<template>
    <div class="container my-5">
      <!-- Header Section -->
      <div class="bg-primary text-white p-4 rounded">
        <h4>{{ matchstore.match.name }}</h4>
        <h5>날짜 : {{showdate  }}</h5>
        <p>시간 : {{time}}</p>
        <p>경기장 : {{matchstore.match.stadiumName}}</p>
        <p>주소 : {{matchstore.match.address}}</p>
      </div>
  
      <!-- Coupon Section -->
      <!-- <div class="d-flex justify-content-between align-items-center mt-4">
        <span>내 쿠폰</span>
        <span>쿠폰 없음</span>
      </div>
      <div class="d-flex justify-content-between align-items-center mt-2">
        <span>캐시/포인트</span>
        <span>0원 사용</span>
      </div> -->
  
      <!-- Payment Section -->
      <div class="mt-4">
        <h6>결제</h6>
        <div class="d-flex justify-content-between mt-2">
          <span>이용 금액</span>
          <span>{{formattedPrice}}원</span>
        </div>
        <div class="d-flex justify-content-between mt-2">
          <span>프로모션 할인</span>
          <span class="text-danger">-{{formattedPromotion}}원</span>
        </div>
        <hr />
        <div class="d-flex justify-content-between mt-2">
          <strong>결제 금액</strong>
          <strong>{{formattedRealPrice}}원</strong>
        </div>
      </div>
  
      <!-- Additional Information Section -->
      <div class="mt-4">
        <h6>이것만은 꼭!</h6>
        <div class="d-flex justify-content-between mt-2">
          <span>부상자 보험</span>
          <i class="bi bi-chevron-right"></i>
        </div>
        <div class="d-flex justify-content-between mt-2">
          <span>환불 안내</span>
          <i class="bi bi-chevron-right"></i>
        </div>
      </div>
  
      <!-- Footer Button -->
      <div class="text-center mt-4">
        <button class="btn btn-warning w-100 py-3">
          5,000원 충전하기
        </button>
      </div>
    </div>
  </template>

<script setup>
import { useMatchStore } from '@/stores/match';
import { ref, computed, onMounted } from 'vue';
const matchstore = useMatchStore()

const date = new Date(matchstore.match.startTime)
const showdate = `${date.getFullYear()}년 ${date.getMonth()+1}월  ${date.getDate()}일 `
const time = matchstore.match.startTime.slice(11,16)
const price = ref(10000)
const promotion = ref(9999)
const realprice = ref(price.value-promotion.value)

// 숫자 포맷팅 함수
const formatNumber = (number) => {
  return new Intl.NumberFormat('ko-KR').format(number);
};

// 포맷팅된 값
const formattedPrice = computed(() => formatNumber(price.value));
const formattedPromotion = computed(() => formatNumber(promotion.value));
const formattedRealPrice = computed(() => formatNumber(price.value - promotion.value));

onMounted(()=>{
  
})

</script>

<style  scoped>

</style>