<template>
    <div class="container mt-5">
        <h2 class="mb-4">예약 리스트</h2>

        <div class="card p-4 shadow">
            <!-- 예약 리스트 테이블 -->
            <div v-if="matchstore.matchManagerList.length > 0" class="table-responsive">
                <table class="table table-striped table-hover text-center">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">매치명</th>
                            <th scope="col">시작 시간</th>
                            <th scope="col">종료 시간</th>
                            <th scope="col">경기장</th>
                            <th scope="col">주소</th>
                        </tr>
                    </thead>
                    <tbody>
                        <MatchManagerListItem
                            v-for="match in matchstore.matchManagerList"
                            :key="match.id"
                            :match="match"
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
import { onMounted } from "vue";
import { useReservationStore } from "@/stores/reservation";
import { useUserStore } from "@/stores/user";
import router from "@/router";
import { useMatchStore } from "@/stores/match";
import MatchManagerListItem from "./MatchManagerListItem.vue";

const store = useReservationStore();
const userstore = useUserStore();
const matchstore = useMatchStore()

// 데이터 로드
onMounted(() => {
    if (!userstore.loginUser.userid) {
        alert("로그인이 필요합니다.");
        router.push({ name: "loginview" });
    } else {
        matchstore.getMatchManagerList(userstore.loginUser.id);
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
