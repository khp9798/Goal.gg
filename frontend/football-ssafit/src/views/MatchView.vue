<template>
    <div class="container mt-5">
        <h2>매치 일정</h2>
        <!-- 모달을 열기 위한 버튼 -->
        <button type="button" id="btn" class="btn btn-outline-dark mt-3 mb-3" @click="openModal">
            {{ selectedRegion || '지역 선택' }}
        </button>

        <!-- 모달 -->
        <div class="modal fade" ref="regionModal" tabindex="-1" aria-labelledby="regionModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <!-- 모달 헤더 -->
                    <div class="modal-header">
                        <h5 class="modal-title" id="regionModalLabel">지역</h5>
                        <button type="button" class="btn-close" @click="closeModal"></button>
                    </div>
                    <!-- 모달 바디 -->
                    <div class="modal-body">
                        <ul class="list-group">
                            <li
                                v-for="region in regions"
                                :key="region"
                                class="list-group-item"
                                @click="selectRegion(region)"
                            >
                                {{ region }}
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <Calender/>
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import Calender from '@/components/match/MatchCalender.vue';
import { Modal } from 'bootstrap';
import { useMatchStore } from '@/stores/match';

const matchstore = useMatchStore()

// 지역 목록
const regions = [
    '서울',
    '경기',
    '인천',
    '강원',
    '대전',
    '세종',
    '충남',
    '충북',
    '대구',
    '경북',
    '부산',
    '울산',
    '경남',
    '광주',
    '전남',
    '전북',
    '제주',
];

// 선택된 지역
const selectedRegion = ref("");
// 모달 참조
const regionModal = ref(null);
let modalInstance = null;

// 모달 열기
const openModal = () => {
    if (!modalInstance) {
        modalInstance = new Modal(regionModal.value);
    }
    modalInstance.show();
};

// 모달 닫기
const closeModal = () => {
    if (modalInstance) {
        modalInstance.hide();
    }
};

// 지역 선택 시
const selectRegion = (region) => {
    selectedRegion.value = region;
    console.log(selectedRegion.value)
    matchstore.getMatchRegionList(selectedRegion.value);
    closeModal();
};


onMounted(()=>{
    matchstore.getMatchRegionList(selectedRegion.value)
})
</script>

<style scoped>
/* 모달 내용 영역 커스터마이징 */
.modal-content {
  border-radius: 10px;
  overflow: hidden;
}

/* 리스트 아이템 스타일 */
.list-group-item {
  font-size: 16px;
  padding: 12px;
  border-bottom: 1px solid #e0e0e0;
  cursor: pointer;
}

.list-group-item:last-child {
  border-bottom: none;
}

/* 리스트 아이템 호버 효과 */
.list-group-item:hover {
  background-color: #f8f9fa;
}
</style>
