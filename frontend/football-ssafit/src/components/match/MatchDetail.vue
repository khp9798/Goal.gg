<template>
  <div class="container mt-4">
    <!-- 상단 이미지 섹션 -->
    <div class="row my-4">
      <div class="col-12">
        <img :src="matchstore.match.image" alt="축구장 이미지" class="img-fluid rounded shadow-sm">
      </div>
    </div>

    <!-- 버튼 섹션 -->
    <div class="mb-4 d-flex justify-content-end gap-2">
      <button :class="userstore.isManagerMode &&
        ['신청 가능', '마감 임박'].includes(matchstore.match.status) &&
        !matchstore.match.managerId
        ? 'btn btn-primary'
        : 'btn btn-secondary disabled'" @click="RegisterManager">
        매니저 신청하기
      </button>

      <button v-if="isLogin" class="btn" :class="statusClass" @click="goReservation">
        {{ matchstore.match.status }}
      </button>
      <button v-else class="btn btn-secondary" @click="goLoginView">로그인하기</button>
    </div>

    <!-- 상세 정보 섹션 -->
    <div class="row g-4">
      <!-- 왼쪽 구장 정보 -->
      <div class="col-md-6">
        <div class="card h-100 shadow-sm  text-center p-4">
          <div class="card-body">
            <h4 class="card-title">{{ matchstore.match.name }}</h4>
            <p v-if="managerName" class="text-success">
              {{ managerName }}님이 매니저로 참여합니다.
            </p>
            <p v-else class="text-danger">
              매치 매니저가 등록되지 않았습니다.
            </p>
            <h6>매치 시간: {{ formattedStartTime }} - {{ formattedEndTime }}</h6>
            <div class="tier">
              <p>
                예상 평균 레벨은
                <strong>{{ matchstore.matchAvgTier || "unRanked" }}</strong>입니다.
              </p>
              <img
                :src="matchstore.matchAvgTier ? `/src/assets/tier/${matchstore.matchAvgTier}.webp` : '/src/assets/tier/unranked.webp'"
                alt="언랭" width="200px" class="img-fluid" />
            </div>
          </div>
        </div>
      </div>

      <!-- 오른쪽 경기장 정보 -->
      <div class="col-md-6">
        <div class="card h-100 shadow-sm text-center p-4">
          <div class="card-body text-center">
            <h4 class="card-title">{{ matchstore.match.stadiumName }}</h4>
            <p>{{ matchstore.match.address }}</p>
            <div class="map-container">
              <KakaoMap :lat="xy.lat" :lng="xy.lng" @onLoadKakaoMap="onLoadKakaoMap">
                <KakaoMapMarker :lat="xy.lat" :lng="xy.lng" />
              </KakaoMap>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- 경기 규칙 섹션 -->
    <MatchRule />

    <!-- 모달 -->
    <div v-if="showModal" class="modal fade show d-block" tabindex="-1" style="background-color: rgba(0, 0, 0, 0.5);">
      <div class="modal-dialog">
        <div class="modal-content">
          <!-- 모달 헤더 -->
          <div class="modal-header">
            <h5 class="modal-title">결제 정보</h5>
            <button type="button" class="btn-close" aria-label="Close" @click="closeModal"></button>
          </div>

          <!-- 모달 바디 -->
          <div class="modal-body">
            <!-- 매치 정보 -->
            <div class="bg-primary text-white p-4 rounded shadow-sm mb-4">
              <h4>{{ matchstore.match.name }}</h4>
              <p>날짜: {{ showdate }}</p>
              <p>시간: {{ matchstore.match.startTime.slice(11, 16) }} - {{ matchstore.match.endTime.slice(11, 16) }}</p>
              <p>경기장: {{ matchstore.match.stadiumName }}</p>
              <p>주소: {{ matchstore.match.address }}</p>
            </div>

            <!-- 결제 정보 -->
            <h6>결제 내역</h6>
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

          <!-- 모달 푸터 -->
          <div class="modal-footer">
            <button class="btn btn-secondary" @click="closeModal">닫기</button>
            <button class="btn btn-warning" @click="initiatePayment">결제하기</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// Vue & Stores
import router from "@/router";
import { useMatchStore } from "@/stores/match";
import { useUserStore } from "@/stores/user";
import { computed, ref, onMounted, watch, onBeforeUpdate, onBeforeMount } from "vue";
import { useRoute } from "vue-router";
import axios from "axios";
import MatchRule from "./MatchRule.vue";
import { KakaoMap, KakaoMapMarker } from "vue3-kakao-maps";


//카카오맵 api
const xy = ref({ lat: 33.450701, lng: 126.570667 });

const onLoadKakaoMap =async (mapRef) => {
  if (window.kakao && kakao.maps.services) {
    const geocoder = new kakao.maps.services.Geocoder();
    console.log("kakao onload")
    await matchstore.getMatch(route.params.id)
    const address = await matchstore.match.address
    console.log(address)
    
    geocoder.addressSearch(address, function (result, status) {
      if (status === kakao.maps.services.Status.OK) {
        console.log(result)
        xy.value = {
          lat: parseFloat(result[0].y),
          lng: parseFloat(result[0].x),
        };
          mapRef.setCenter(new kakao.maps.LatLng(xy.value.lat, xy.value.lng));
      } else {
        console.error('주소 검색 실패:', status);
      }
    });
  } else {
    console.error('Kakao Maps API가 로드되지 않았습니다.');
  }
};


// Stores & Route
const matchstore = useMatchStore();
const userstore = useUserStore();
const route = useRoute();

// 상태 값
const showModal = ref(false);
const managerName = ref("");
const price = ref(10000);
const promotion = ref(2000);

// 상태별 버튼 클래스
const statusClass = computed(() => {
  switch (matchstore.match.status) {
    case "신청 가능":
      return "btn-primary";
    case "마감 임박":
      return "btn-danger";
    default:
      return "btn-secondary";
  }
});

// 로그인 상태
const isLogin = computed(() => !!userstore.loginUser.userid);

const showdate = computed(() => {
  if (!matchstore.match.startTime) {
    return "날짜 정보 없음";
  }

  const date = new Date(matchstore.match.startTime);

  // Date 객체가 유효하지 않을 경우 기본값 반환
  if (isNaN(date.getTime())) {
    return "유효하지 않은 날짜";
  }

  return `${date.getFullYear()}년 ${date.getMonth() + 1}월 ${date.getDate()}일`;
});



// 포맷팅된 금액
const formatNumber = (number) => new Intl.NumberFormat("ko-KR").format(number);
const formattedPrice = computed(() => formatNumber(price.value));
const formattedPromotion = computed(() => formatNumber(promotion.value));
const formattedRealPrice = computed(() => formatNumber(price.value - promotion.value));

// 매치 매니저 등록
const RegisterManager = () => {
  matchstore.RegisterManager({ ...matchstore.match, managerId: userstore.loginUser.id });
  alert("매치 매니저로 신청되었습니다.");
};

// 예약 및 결제
const goReservation = () => {
  if (["신청 마감", "경기 취소"].includes(matchstore.match.status)) {
    alert(matchstore.match.status === "신청 마감" ? "경기가 마감되었습니다." : "취소된 경기입니다.");
  } else {
    showModal.value = true;
  }
};

const goLoginView = () => router.push({ name: "loginview" });
const closeModal = () => (showModal.value = false);

// 결제 처리
const initiatePayment = async () => {

  try {
    const response = await axios.post("http://localhost:8080/order/pay/ready", {
      id: matchstore.match.id,
      name: "테스트 상품",
      totalPrice: 5000,
    });
    if (response.data.next_redirect_pc_url) window.location.href = response.data.next_redirect_pc_url;
  } catch (error) {
    console.error("결제 요청 실패:", error);
  }



};

// 데이터 로드
onMounted(async () => {
  matchstore.getMatchAvgTier(route.params.id);
  console.log("mount end")
});


watch(
  () => matchstore.match,
  (newValue) => {
    managerName.value = newValue.managerName;
  },
  { deep: true }
);




const formattedStartTime = computed(() => {
  if (!matchstore.match.startTime) return "시간 정보 없음";

  const startTime = new Date(matchstore.match.startTime);
  if (isNaN(startTime.getTime())) return "유효하지 않은 시간";

  return `${startTime.getHours().toString().padStart(2, "0")}:${startTime.getMinutes().toString().padStart(2, "0")}`;
});

const formattedEndTime = computed(() => {
  if (!matchstore.match.endTime) return "시간 정보 없음";

  const endTime = new Date(matchstore.match.endTime);
  if (isNaN(endTime.getTime())) return "유효하지 않은 시간";

  return `${endTime.getHours().toString().padStart(2, "0")}:${endTime.getMinutes().toString().padStart(2, "0")}`;
});





</script>




<style scoped>
/* 카드 섀도우 및 테두리 */
.card {
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.map-container {
  width: 100%;
  max-width: 100%; /* 부모 컨테이너를 넘어가지 않도록 제한 */
  height: 300px; /* 적절한 높이 지정 */
  overflow: hidden; /* 내용이 넘어가는 경우 잘리도록 설정 */
  border-radius: 10px; /* 둥근 모서리 추가 */
  position: relative; /* 자식 요소 배치 기준 설정 */
}

.map-container > div {
  width: 100%;
  height: 100%; /* 부모 크기에 맞게 설정 */
  position: absolute;
}
</style>
