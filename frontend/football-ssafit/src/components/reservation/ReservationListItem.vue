<template>
    <tr @click="goDetail" class="reservation-row">
        <td class="text-truncate" title="{{ props.reservation.name }}">{{ props.reservation.name }}</td>
        <td>{{ formatDate(props.reservation.startTime) }}</td>
        <td>{{ formatDate(props.reservation.endTime) }}</td>
        <td>
            <span :class="statusClass">{{ props.reservation.status  }}</span>
        </td>
        <td>{{ formatDate(props.reservation.reservationDate) }}</td>
    </tr>
</template>

<script setup>
import router from "@/router";
import { computed } from "vue";


// Props 정의
const props = defineProps({
    reservation: Object,
});

// 상세 페이지 이동 함수
const goDetail = () => {
    router.push({ name: "matchDetail", params: { id: props.reservation.matchId } });
};

// 날짜 포맷팅 함수
const formatDate = (date) => {
    return date.replace("T", " ").slice(0, 16);
};

// 상태별 스타일 클래스 계산
const statusClass = computed(() => {
    const status = props.reservation.status;
    if (status === '신청 가능') {
        return "badge bg-success";
    } else if (status === "경기 취소") {
        return "badge bg-warning text-dark";
    } else if (status === "마감 임박") {
        return "badge bg-danger";
    } else {
        return "badge bg-secondary";
    }
});
</script>

<style scoped>
/* 예약 항목 행 스타일 */
.reservation-row {
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.reservation-row:hover {
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
