<template>
    <tr @click="goDetail" class="match-row">
        <td class="text-truncate" title="{{ props.match.name }}">{{ props.match.name }}</td>
        <td>{{ formatDate(props.match.startTime) }}</td>
        <td>{{ formatDate(props.match.endTime) }}</td>
        <td>
            <span>{{ props.match.stadiumName }}</span>
        </td>
        <td>{{ props.match.address }}</td>
    </tr>
</template>

<script setup>
import router from "@/router";
import { computed } from "vue";


// Props 정의
const props = defineProps({
    match: Object,
});

// 상세 페이지 이동 함수
const goDetail = () => {
    router.push({ name: "matchDetail", params: { id: props.match.id } });
};

// 날짜 포맷팅 함수
const formatDate = (date) => {
    return date.replace("T", " ").slice(0, 16);
};

// // 상태별 스타일 클래스 계산
// const statusClass = computed(() => {
//     const status = props.reservation.status;
//     if (status === "완료") {
//         return "badge bg-success";
//     } else if (status === "대기 중") {
//         return "badge bg-warning text-dark";
//     } else if (status === "취소됨") {
//         return "badge bg-danger";
//     } else {
//         return "badge bg-secondary";
//     }
// });
</script>

<style scoped>
/* 예약 항목 행 스타일 */
.match-row {
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.match-row:hover {
    background-color: #f1f1f1;
}

/* 텍스트 잘림 방지 */
.text-truncate {
    max-width: 200px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
</style>
