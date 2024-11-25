<template>
    <tr class="match-row">
        <td  @click="goDetail" class="text-truncate" title="{{ props.match.name }}">{{ props.match.name }}</td>
        <td @click="goDetail">{{ formatDate(props.match.startTime) }}</td>
        <td @click="goDetail">{{ formatDate(props.match.endTime) }}</td>
        <td @click="goDetail">
            <span>{{ props.match.stadiumName }}</span>
        </td>
        <td @click="goDetail">{{ props.match.address }}</td>
        <td @click="goDetail">{{props.match.number}}/18</td>
        <td @click="goDetail">{{ props.match.status }}</td>
        <td ><button class="btn-primary" @click="goEvaluateUserStat(props.match.id)">유저 능력치 평가하기</button></td>
    </tr>
</template>

<script setup>
import router from "@/router";
import { useReservationStore } from "@/stores/reservation";
import { computed } from "vue";
const reservationstore = useReservationStore()

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

const goEvaluateUserStat = function(matchid){
    reservationstore.getMatchManagerEvaluateList(matchid)
    router.push({name : 'userstatevaluateview', params : {id : matchid}} )
}

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
