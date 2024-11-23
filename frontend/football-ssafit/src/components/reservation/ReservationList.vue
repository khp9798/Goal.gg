<template>
    <div class="container mt-5">
        <h2 class="mb-4">예약 리스트</h2>

        <div class="card p-4 shadow">
            <!-- 예약 리스트 테이블 -->
            <div v-if="store.reservationList.length > 0" class="table-responsive">
                <table class="table table-striped table-hover text-center">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">매치명</th>
                            <th scope="col">시작 시간</th>
                            <th scope="col">종료 시간</th>
                            <th scope="col">상태</th>
                            <th scope="col">예약 시간</th>
                        </tr>
                    </thead>
                    <tbody>
                        <ReservationListItem
                            v-for="reservation in store.reservationList"
                            :key="reservation.id"
                            :reservation="reservation"
                        />
                    </tbody>
                </table>
            </div>

            <!-- 예약 리스트 없음 -->
            <div v-else class="text-center py-5">
                <h4>예약 내역이 없습니다.</h4>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, onMounted } from "vue";
import ReservationListItem from "./ReservationListItem.vue";
import { useReservationStore } from "@/stores/reservation";
import { useUserStore } from "@/stores/user";
import router from "@/router";

const store = useReservationStore();
const userstore = useUserStore();

// 데이터 로드
onMounted(() => {
    if (!userstore.loginUser.userid) {
        alert("로그인이 필요합니다.");
        router.push({ name: "loginview" });
    } else {
        store.getList(userstore.loginUser.userid);
    }
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

.table {
    margin-bottom: 0;
}

.table-responsive {
    border-radius: 10px;
    overflow: hidden;
}

th,
td {
    vertical-align: middle;
}

.text-muted {
    color: #6c757d !important;
}
</style>
