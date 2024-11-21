<template>
    <div class="container">
        경기장 상세입니다
        <div>경기장 이미지</div>
        <img :src="stadiumstore.stadium.image" class="card-img-top" alt="..." width="300px">
        <div>경기장 이름</div>
        {{ stadiumstore.stadium.name }}
        <hr>
        <div>경기장 주소</div>
        {{ stadiumstore.stadium.address }}
        <hr>
        <div>경기장 가격</div>
        {{ stadiumstore.stadium.price }}
        <hr>
        <div>경기장 수용인원</div>
        {{ stadiumstore.stadium.capacity }}
        <div>
            <vue-cal ref="vueCalRef" style="height:0px;" :time =false active-view="week"
                :disable-views="['years', 'year', 'month', 'day']" locale="ko" :events="events" events-on-month-view="short"
                @cell-click="SearchStadiumDayMatch">

                <template #arrow-prev>
                    <i class="icon material-icons">&lt;</i>
                </template>
                <template #arrow-next>
                    <i class="icon material-icons">&gt;</i>
                </template>
            </vue-cal>

        </div>
        <div style="height: 10rem;">

        </div>
        <!-- {{ matchstore.StadiumDayMatchList }} -->
        <h2>현재 매치 목록</h2>
        <div class=" justify-content-start overflow-auto">
            <StadiumMatch v-for="match in matchstore.StadiumDayMatchList" :match="match" />
        </div>
    </div>
</template>

<script setup>
import { useStadiumStore } from '@/stores/stadium';
import { onMounted, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import StadiumMatch from '@/components/stadium/StadiumMatch.vue'
import { useMatchStore } from '@/stores/match';
import VueCal from 'vue-cal';
import 'vue-cal/dist/vuecal.css';
import router from '@/router';

const vueCalRef = ref(null);
const route = useRoute()
const stadiumstore = useStadiumStore()
const matchstore = useMatchStore()


onMounted(() => {
    console.log(route.params.id)
    stadiumstore.getStadium(route.params.id)
    matchstore.stadiumMatchList = []
    console.log('Vue Cal Default Day:', vueCalRef.value.now);
    const date = new Date(vueCalRef.value.now);

// YYYY-MM-DD HH:mm:ss 형식으로 변환
const formatDate = (date) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

// 결과 출력
console.log(formatDate(date)); // 2024-11-22 18:00:00
    matchstore.getStadiumDayMatch(formatDate(date), route.params.id)
})

///////////////////////////
// vue-cal에 맞는 형식으로 변환
const events = ref([]);
watch(
    () => matchstore.stadiumMatchList,
    (newValue) => {
        events.value = newValue.map((item) => ({
            start: item.startTime.replace('T', ' ').slice(0, 16), // 'T'를 ' '로 변환하고 시간 초단위 제거
            end: item.endTime.replace('T', ' ').slice(0, 16),
            title: item.name,
            content: `${item.stadiumName} <i class="icon material-icons" style="color : ${item.status === "마감 임박" ? 'red' : 'black'};">${item.status}</i>`,
            class: item.status === "신청 마감" ? "end" : item.status === "경기 취소" ? "cancle" : "",
            matchId : item.id
        }));
        
        console.log('변환된 Events:', events.value);
    }
);

// 주어진 날짜 문자열
const dateStr = ref('');


const SearchStadiumDayMatch = (day) => {
    console.log(day.date)
    dateStr.value = day.date

    // Date 객체로 변환
const date = new Date(dateStr.value);

// UTC로 변환하여 원하는 시간대(18:00:00) 조정

// YYYY-MM-DD HH:mm:ss 형식으로 변환
const formatDate = (date) => {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

// 결과 출력
console.log(formatDate(date)); // 2024-11-22 18:00:00
matchstore.getStadiumDayMatch(formatDate(date), route.params.id)

}

</script>

<style lang="scss" scoped>

</style>