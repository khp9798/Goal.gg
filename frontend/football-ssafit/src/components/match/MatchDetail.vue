<template>

    <div class="container mt-4">
        <!-- 상단 이미지 섹션 -->
        <div class="row my-4">
            <div class="col-12">
                <img :src="matchstore.match.image" alt="축구장 이미지" class="img-fluid rounded">
            </div>
        </div>
        <div class="m-2 d-flex justify-content-end">
            <button v-if="isLogin" class="btn btn-primary mx-1" :class="statusClass" @click="goReservation">{{ matchstore.match.status }}</button>
            <button v-if="!isLogin" class="btn btn-secondary mx-1" @click="goLoginView">로그인하기</button>
        </div>
        <div class="row mt-4 h-100">
            <!-- 왼쪽 구장 정보 -->
            <div class="col-md-6 d-flex align-items-stretch">
                <div class="card flex-grow-1">
                    <div class="card-body">
                        <h5 class="card-title">구장 정보</h5>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Source</th>
                                    <th>Info</th>
                                    <th>Charge</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>8x8 축구 매치</td>
                                    <td>70×37m 실외 인조잔디</td>
                                    <td>110000</td>
                                </tr>
                                <tr>
                                    <td>A 구장</td>
                                    <td>37×20m 실외 인조잔디</td>
                                    <td>50000</td>
                                </tr>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 오른쪽 경기장 정보 -->
            <div class="col-md-6 d-flex align-items-stretch text-center">
                <div class="card flex-grow-1">
                    <div class="card-body">
                        <h4 class="card-title">{{ matchstore.match.stadiumName }}</h4>
                        <p>{{ matchstore.match.address }}</p>
                        <div class="tier">
                            <p>예상 평균 레벨은 <strong>{{ matchstore.matchAvgTier ? matchstore.matchAvgTier : "unRanked" }}</strong>입니다.
                            </p>
                            <img :src="`/src/assets/${matchstore.matchAvgTier}.webp`" alt="언랭" width="200px">
                        </div>


                    </div>
                </div>
            </div>

            <div class="match-guidelines mt-4">
                <div class="card">
                    <div class="card-header">
                        <h4>매치 진행 방식</h4>
                    </div>
                    <div class="card-body">
                        <!-- 매치 규칙 -->
                        <div>
                            <h5>매치 규칙</h5>
                            <ul>
                                <li>모든 파울은 사이드라인에서 킥인</li>
                                <li>골키퍼에게 백패스 가능 손으로는 잡으면 안 돼요</li>
                                <li>사람을 향한 태클 금지</li>
                            </ul>
                        </div>

                        <!-- 진행 방식 -->
                        <div>
                            <h5>진행 방식</h5>
                            <ul>
                                <li>풋살화와 개인 음료만 준비하세요</li>
                                <li>매니저가 경기 진행을 도와드려요</li>
                                <li>골키퍼와 휴식을 공평하게 돌아가면서 해요</li>
                                <li>레벨 데이터를 기준으로 팀을 나눠요</li>
                                <li>친구끼리 와도 팀 실력이 맞지 않으면 다른 팀이 될 수 있어요</li>
                            </ul>
                        </div>

                        <!-- 알아두면 좋아요 -->
                        <div>
                            <h5>알아두면 좋아요</h5>
                            <ul>
                                <li>서로 존중하고 격려하며 함께 즐겨요</li>
                                <li>매일 4,500여 명이 팀 없이도 풋살을 즐기고 있어요</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    
    <!-- ddddddddddddddddddddddddddddddddddd -->
    
    <!-- 모달 -->
    <div
      v-if="showModal"
      class="modal fade show"
      style="display: block; background-color: rgba(0, 0, 0, 0.5);"
      tabindex="-1"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <!-- 모달 헤더 -->
          <div class="modal-header">
            <h5 class="modal-title">결제 정보</h5>
            <button type="button" class="btn-close" aria-label="Close" @click="closeModal"></button>
          </div>

          <!-- 모달 바디 -->
          <div class="modal-body">
            <!-- Header Section -->
            <div class="bg-primary text-white p-4 rounded">
              <h4>{{ matchstore.match.name }}</h4>
              <h5>날짜 : {{ showdate }}</h5>
              <p>시간 : {{ matchstore.match.startTime.slice(11,16) }} - {{ matchstore.match.endTime.slice(11,16) }}</p>
              <p>경기장 : {{ matchstore.match.stadiumName }}</p>
              <p>주소 : {{ matchstore.match.address }}</p>
            </div>

            <!-- Payment Section -->
            <div class="mt-4">
              <h6>결제</h6>
              <div class="d-flex justify-content-between mt-2">
                <span>이용 금액</span>
                <span>{{ formattedPrice }}원</span>
              </div>
              <div class="d-flex justify-content-between mt-2">
                <span>프로모션 할인</span>
                <span class="text-danger">-{{ formattedPromotion }}원</span>
              </div>
              <hr />
              <div class="d-flex justify-content-between mt-2">
                <strong>결제 금액</strong>
                <strong>{{ formattedRealPrice }}원</strong>
              </div>
            </div>
          </div>

          <!-- 모달 푸터 -->
          <div class="modal-footer">
            <button class="btn btn-secondary" @click="closeModal">닫기</button>
            <button class="btn btn-warning" @click="initiatePayment">결제하기</button>
          </div>
        </div>
      </div>
    </div>

</template>

<script setup>
import router from '@/router';
import { useMatchStore } from '@/stores/match';
import { useUserStore } from '@/stores/user';
import { computed, onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute()

const userstore = useUserStore()


const matchstore = useMatchStore();

const showModal = ref(false);

const statusClass = computed(()=>{
    const status = matchstore.match.status
    if (status === "신청 가능") {
    return "btn-primary"; // 파란색 버튼
  } else if (status === "마감 임박") {
    return "btn-danger"; // 빨간색 버튼
  } else {
    return "btn-secondary"; // 회색 버튼
  }
});

const isLogin = computed(() => {
    return userstore.loginUser.userid ? true : false;
});

const goReservation = function(){
    if(matchstore.match.status=='신청 마감'){
        alert("경기가 마감되었습니다")
    } else if(matchstore.match.status=='경기 취소'){
        alert("취소된 경기입니다")
    } else{
        showModal.value = true;
    }
}

const goLoginView = function(){
    // console.log(store.match.status)
    router.push({name : 'loginview'})
}



const closeModal = () => {
  showModal.value = false;
};

// 날짜 및 시간 포맷팅
const date = new Date(matchstore.match.startTime);
const showdate = `${date.getFullYear()}년 ${date.getMonth() + 1}월 ${date.getDate()}일`;

// 결제 정보
const price = ref(10000);
const promotion = ref(9999);

// 숫자 포맷팅 함수
const formatNumber = (number) => {
  return new Intl.NumberFormat('ko-KR').format(number);
};

// 포맷팅된 값
const formattedPrice = computed(() => formatNumber(price.value));
const formattedPromotion = computed(() => formatNumber(promotion.value));
const formattedRealPrice = computed(() => formatNumber(price.value - promotion.value));
onMounted(() => {
    matchstore.getMatch(route.params.id)
    matchstore.getMatchAvgTier(route.params.id)
    userstore.loginUser.userid ? true : false;
    matchstore.match.startTime
})

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



<style  scoped>

</style>