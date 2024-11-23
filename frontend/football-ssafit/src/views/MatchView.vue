<template>
    <div class="container mt-5">
        <h2 class="mb-4">매치 일정</h2>

        <!-- 지역 선택 버튼 -->
        <div class="text-center mb-4">
            <button type="button" class="btn btn-outline-dark" @click="openModal">
                {{ selectedRegion || "지역 선택" }}
            </button>
        </div>

        <!-- 캘린더 컴포넌트 -->
        <div class="card p-4 shadow">
            <Calender />
        </div>

        <!-- 지역 선택 모달 -->
        <div class="modal fade" ref="regionModal" tabindex="-1" aria-labelledby="regionModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <!-- 모달 헤더 -->
                    <div class="modal-header">
                        <h5 class="modal-title" id="regionModalLabel">지역 선택</h5>
                        <button type="button" class="btn-close" @click="closeModal"></button>
                    </div>
                    <!-- 모달 바디 -->
                    <div class="modal-body">
                        <ul class="list-group">
                            <li
                                v-for="region in regions"
                                :key="region"
                                class="list-group-item list-group-item-action"
                                @click="selectRegion(region)"
                            >
                                {{ region }}
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import Calender from "@/components/match/MatchCalender.vue";
import { Modal } from "bootstrap";
import { useMatchStore } from "@/stores/match";

const matchstore = useMatchStore();

// 지역 목록
const regions = [
    "서울", "경기", "인천", "강원", "대전", "세종", "충남", "충북",
    "대구", "경북", "부산", "울산", "경남", "광주", "전남", "전북", "제주"
];

// 선택된 지역
const selectedRegion = ref("");
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
    modalInstance?.hide();
};

// 지역 선택
const selectRegion = (region) => {
    selectedRegion.value = region;
    matchstore.getMatchRegionList(region);
    closeModal();
};

// 초기 데이터 로드
onMounted(() => {
    matchstore.getMatchRegionList(selectedRegion.value);
});
</script>

<style scoped>
h2 {
    font-weight: bold;
    color: #343a40;
}

.card {
    background-color: #f8f9fa;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.list-group-item {
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.list-group-item:hover {
    background-color: #f1f1f1;
}

.text-muted {
    color: #6c757d !important;
}

button.btn-outline-dark {
    font-weight: bold;
    padding: 10px 20px;
}

button.btn-outline-dark:hover {
    background-color: #343a40;
    color: #fff;
}
</style>
