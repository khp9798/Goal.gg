<template>
  <div class="match-form-wrapper">
    <div class="match-form-container">
      <h2>매치 등록</h2>
      <form @submit.prevent="registerMatch">
        <div class="form-group">
          <label for="name">매치 이름</label>
          <input id="name" v-model="match.name" type="text" placeholder="매치 이름을 입력하세요" required />
        </div>
        <div class="form-group">
          <label for="stadium">경기장</label>
          <div class="stadium-select">
            <input
              type="text"
              readonly
              placeholder="경기장을 검색하세요"
              :value="selectedStadium?.name || ''"
              @click="openModal"
              required
            />
            <button type="button" @click="openModal">검색</button>
          </div>
        </div>
        <div class="form-group">
          <label for="manager">매니저 ID</label>
          <input id="manager" type="text" :placeholder="userstore.loginUser.userid" readonly />
        </div>
        <div class="form-group">
          <label for="manager">매니저 이름</label>
          <input id="manager" type="text" :placeholder="userstore.loginUser.name" readonly />
        </div>
        <div class="form-group">
          <label for="start_time">시작 시간</label>
          <input id="start_time" v-model="match.startTime" type="datetime-local" required />
        </div>
        <div class="form-group">
          <label for="end_time">종료 시간</label>
          <input id="end_time" v-model="match.endTime" type="datetime-local" required />
        </div>
        
        <button type="submit">등록</button>
      </form>
      <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>

      <!-- 경기장 검색 모달 -->
      <div v-if="isModalOpen" class="modal">
        <div class="modal-content">
          <h3>경기장 검색</h3>
          <input 
            type="text" 
            :value="searchQuery" 
            @input="updateSearchQuery" 
            placeholder="경기장 이름을 검색하세요" 
          />
          <ul>
            <li
              v-for="stadium in filteredStadiums"
              :key="stadium.id"
              @click="selectStadium(stadium)"
              class="stadium-item"
            >
              {{ stadium.name }}
            </li>
          </ul>
          <button @click="closeModal">닫기</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useStadiumStore } from '@/stores/stadium';
import { useUserStore } from "@/stores/user";
import { useMatchStore } from "@/stores/match";

// Store 설정
const userstore = useUserStore();
const stadiumstore = useStadiumStore();

// onMounted에서 경기장 리스트 가져오기
onMounted(() => {
  stadiumstore.getStadiumList();
});

// 상태 변수 설정
const match = ref({
  name: "",
  stadiumId: -1 || selectedStadium?.value?.id,
  managerId: userstore.loginUser.id,
  startTime: "",
  endTime: "",
});

const isModalOpen = ref(false);
const searchQuery = ref("");
const selectedStadium = ref(null);
const matchstore = useMatchStore()

// 필터링된 경기장 목록
const filteredStadiums = computed(() =>
  stadiumstore.stadiumlist.filter((stadium) =>
    stadium.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
);

// 모달 열기/닫기
const openModal = () => {
  isModalOpen.value = true;
  searchQuery.value = "";
};

const closeModal = () => {
  console.log(selectedStadium.value);
  isModalOpen.value = false;
};

// 검색어 업데이트
const updateSearchQuery = (event) => {
  searchQuery.value = event.target.value;
};

// 경기장 선택
const selectStadium = (stadium) => {
  selectedStadium.value = stadium;
  match.value.stadiumId = stadium.id;
  closeModal();
};

// 매치 등록 핸들러
const registerMatch = () => {
  const now = new Date();
  const startTime = new Date(match.value.startTime);
  const endTime = new Date(match.value.endTime);

  if (startTime <= now) {
    errorMessage.value = "시작 시간은 현재 시간 이후여야 합니다.";
    return;
  }
  if (endTime <= startTime) {
    errorMessage.value = "종료 시간은 시작 시간 이후여야 합니다.";
    return;
  }
  if (match.value.name===null){
    errorMessage.value = "매치 이름을 입력하세요";
    return
  }
  if (match.value.stadiumId===-1){
    errorMessage.value = "경기장을 선택해주세요";
    return
  }
  errorMessage.value = "";
  console.log("매치 등록 데이터:", match.value);
  matchstore.registMatch(match.value)
};

const errorMessage = ref("");
</script>
  
<style scoped>
  .match-form-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    padding: 20px;
  }

  .match-form-container {
    width: 100%;
    max-width: 500px;
    padding: 40px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background-color: #e9f7ef;
  }
  
  h2 {
    text-align: center;
    margin-bottom: 20px;
    color: #2e7d32;
  }
  
  .form-group {
    margin-bottom: 15px;
  }
  
  label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: #2e7d32;
  }
  
  input,
  select,
  button {
    width: 100%;
    padding: 10px;
    border: 1px solid #66bb6a;
    border-radius: 4px;
    font-size: 16px;
  }
  
  button {
    background-color: #43a047;
    color: white;
    font-weight: bold;
    cursor: pointer;
  }
  
  button:hover {
    background-color: #2e7d32;
  }
  
  .stadium-select {
    display: flex;
    gap: 10px;
  }
  
  .error-message {
    color: red;
    margin-top: 10px;
    text-align: center;
    font-weight: bold;
  }
  
  .modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .modal-content {
    background: white;
    padding: 20px;
    border-radius: 8px;
    width: 400px;
    max-height: 70%;
    overflow-y: auto;
    border: 2px solid #2e7d32;
  }
  
  .modal-content h3 {
    margin-bottom: 10px;
    text-align: center;
    color: #2e7d32;
  }
  
  .stadium-item {
    padding: 10px;
    border: 1px solid #66bb6a;
    border-radius: 4px;
    margin-bottom: 5px;
    cursor: pointer;
  }
  
  .stadium-item:hover {
    background-color: #e8f5e9;
  }
</style>
