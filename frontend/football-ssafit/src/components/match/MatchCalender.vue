<!-- https://antoniandre.github.io/vue-cal/         vue-cal 공식문서 -->

<template>
    <div>
        <vue-cal style="height: 600px;" :time-from="8 * 60" :time-to="24 * 60"  active-view="month"
            :disable-views="['years', 'year', 'week']" locale="ko" :events="events"
            events-count-on-month-view
            @event-click="onEventClick">
            
            <template #arrow-prev>
                <i class="icon material-icons">&lt;</i>
            </template>
            <template #arrow-next>
                <i class="icon material-icons">&gt;</i>
            </template>
        </vue-cal>

    </div>
</template>

<script setup>
import VueCal from 'vue-cal';
import 'vue-cal/dist/vuecal.css';
import { onMounted, ref, watch } from 'vue';
import { useMatchStore } from '@/stores/match';
import router from '@/router';

const matchStore = useMatchStore();

// vue-cal에 맞는 형식으로 변환
const events = ref([]);

onMounted(() => {
    matchStore.getMatchList();
});

watch(
    () => matchStore.matchList,
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

// 이벤트 클릭 핸들러
const onEventClick = (event) => {
    console.log('클릭된 이벤트:', event);
    // 다른 페이지로 이동 (예: /event/:id)
    router.push({name:'matchDetail',params : {id : event.matchId}});
};
</script>


<style>



/* 매치 상태로 백그라운드 컬러를 다르게 설정 */
.end{
    background-color: #FF6B6B !important; /* 밝은 빨강 */
  color: white !important;            /* 텍스트 흰색 */
  opacity: 0.8;                       /* 투명도 */
  border: 1px solid #FF4444;          /* 테두리 색상 */
  text-decoration: none;              /* 밑줄 제거 */
}

.cancle {
    background-color: #9E9E9E !important; /* 회색 */
  color: #FFFFFF !important;            /* 텍스트 흰색 */
  opacity: 0.5;                         /* 더 강한 투명도 */
  border: 1px dashed #757575;           /* 점선 테두리 */
  text-decoration: line-through;        /* 취소선 */
}
</style>
