<template>
    <div class="container mt-5">
        <div class="row">
            <!-- 경기장 이미지 및 기본 정보 -->
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <img :src="stadiumstore.stadium.image" class="card-img-top" alt="경기장 이미지" />
                    <div class="card-body">
                        <h4 class="card-title">{{ stadiumstore.stadium.name }}</h4>
                        <p class="card-text text-muted mb-1"><strong>주소:</strong> {{ stadiumstore.stadium.address }}</p>
                        <p class="card-text text-muted mb-1"><strong>가격:</strong> {{ stadiumstore.stadium.price }}원</p>
                        <p class="card-text text-muted"><strong>수용 인원:</strong> {{ stadiumstore.stadium.capacity }}명</p>
                    </div>
                </div>
            </div>


            <!-- 캘린더와 매치 목록 -->
            <div class="col-md-6">
                <div class="card shadow-sm mb-4">
                    <div class="card-body">
                        <h5 class="card-title">경기 일정</h5>
                        <vue-cal
                            ref="vueCalRef"
                            class="border rounded"
                            style="height: 300px;"
                            :time="false"
                            active-view="month"
                            :disable-views="['years', 'year', 'week', 'day']"
                            locale="ko"
                            :events="events"
                            :show-week-numbers="false"
                            @cell-click="SearchStadiumDayMatch"
                        >
                            <template #arrow-prev>
                                <i class="icon material-icons">&lt;</i>
                            </template>
                            <template #arrow-next>
                                <i class="icon material-icons">&gt;</i>
                            </template>
                        </vue-cal>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">매치 목록</h5>
                        <table class="table table-striped table-hover text-center">
                            <thead class="table-dark">
                                <tr>
                                    <th>매치명</th>
                                    <th>시작 시간</th>
                                    <th>종료 시간</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <StadiumMatch
                                    v-for="match in matchstore.StadiumDayMatchList"
                                    :key="match.id"
                                    :match="match"
                                />
                                <tr v-if="matchstore.StadiumDayMatchList.length === 0">
                                    <td colspan="4" class="text-muted">해당 날짜에는 매치가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useStadiumStore } from "@/stores/stadium";
import { onMounted, ref, watch } from "vue";
import { useRoute } from "vue-router";
import StadiumMatch from "@/components/stadium/StadiumMatch.vue";
import { useMatchStore } from "@/stores/match";
import VueCal from "vue-cal";
import "vue-cal/dist/vuecal.css";

const vueCalRef = ref(null);
const route = useRoute();
const stadiumstore = useStadiumStore();
const matchstore = useMatchStore();

onMounted(() => {
    stadiumstore.getStadium(route.params.id);
    matchstore.getStadiumMatch(route.params.id)
    console.log("마운트됨")
    console.log(vueCalRef.value)
    const date = new Date(vueCalRef.value.now);

    const formatDate = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        const hours = "00";
        const minutes = "00";
        const seconds = "00";
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    };
    const formatDate2 = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        const hours = "23";
        const minutes = "59";
        const seconds = "59";
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    };
    console.log(formatDate(date))
    console.log(formatDate2(date))

    matchstore.getStadiumDayMatch(formatDate(date), formatDate2(date), route.params.id);
});

const events = ref([]);
watch(
  () => matchstore.stadiumMatchList,
  (newValue) => {
    events.value = newValue.map((item) => ({
      start: item.startTime.replace('T', ' ').slice(0, 16), // 'T'를 ' '로 변환
      end: item.endTime.replace('T', ' ').slice(0, 16),
      title: item.name,
      class: item.status === "신청 마감" ? "end" : item.status === "경기 취소" ? "cancel" : "",
      matchId: item.id,
    }));
    console.log("변환된 Events:", events.value); // 로그로 데이터 확인
    
  }
);


const SearchStadiumDayMatch = (day) => {
    const date = new Date(day);
    const formatDate = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        const hours = "00";
        const minutes = "00";
        const seconds = "00";
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    };
    const formatDate2 = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        const hours = "23";
        const minutes = "59";
        const seconds = "59";
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    };
    console.log(formatDate(date))
    console.log(formatDate2(date))

    matchstore.getStadiumDayMatch(formatDate(date), formatDate2(date), route.params.id);
};
</script>

<style scoped>
.card {
    border-radius: 10px;
    background-color: #f8f9fa;
}

.card-title {
    font-weight: bold;
    color: #343a40;
}

.table {
    margin-bottom: 0;
}

.table-responsive {
    border-radius: 10px;
    overflow: hidden;
}

th, td {
    vertical-align: middle;
}

.text-muted {
    color: #6c757d !important;
}
</style>
