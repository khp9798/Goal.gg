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
import { onBeforeMount, onBeforeUpdate, onMounted, ref, watch } from 'vue';
import { useMatchStore } from '@/stores/match';
import router from '@/router';
import { useUserStore } from '@/stores/user';

const props = defineProps({
    region : String
})

const matchStore = useMatchStore();

// vue-cal에 맞는 형식으로 변환
const events = ref([]);

const userstore = useUserStore()

onMounted(() => {
    console.log(props.region)
    matchStore.getMatchRegionList(props.region === undefined? "":props.region);
});

watch(
    () => matchStore.matchList,
    (newValue) => {
        if(newValue.length>0){
            events.value = newValue.map((item) => ({
            start: item.startTime.replace('T', ' ').slice(0, 16), // 'T'를 ' '로 변환하고 시간 초단위 제거
            end: item.endTime.replace('T', ' ').slice(0, 16),
            title: item.name,
            content: `${item.stadiumName} <i class="icon material-icons" style="color : ${item.status === "마감 임박" ? 'red' : 'black'}; font-weight:${item.status === "마감 임박" ? 'bold' : ''}">${item.status}</i>`,
            class: item.status === "신청 마감" ? "end" : item.status === "경기 취소" ? "cancle" : "start", 
            matchId : item.id
        }));
        }
        else{
            events.value = []
        }
        
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
    background-color: #9E9E9E !important; /* 밝은 빨강 */
  color: white !important;            /* 텍스트 흰색 */
  opacity: 0.5;                       /* 투명도 */
  text-decoration: none;              /* 밑줄 제거 */
    border: 1px dashed #757575;           /* 점선 테두리 */

}

.cancle {
    background-color: #9E9E9E !important; /* 회색 */
  color: #FFFFFF !important;            /* 텍스트 흰색 */
  opacity: 0.5;                         /* 더 강한 투명도 */
  border: 1px solid #3e3e3e;           /* 점선 테두리 */
  text-decoration: line-through;        /* 취소선 */

}
.start {
  border: 1px solid #757575;           /* 점선 테두리 */

  text-decoration: none;              /* 밑줄 제거 */
  
}



/* Green-theme. */
.vuecal__menu, .vuecal__cell-events-count {background-color: #42b983;}
.vuecal__title-bar {background-color: #e4f5ef;}
.vuecal__cell--today, .vuecal__cell--current {background-color: rgba(20, 150, 107, 0.4);}
.vuecal:not(.vuecal--day-view) .vuecal__cell--selected {background-color: rgba(146, 190, 52, 0.4);}
.vuecal__cell--selected:before {border-color: rgba(66, 185, 131, 0.5);}
/* Cells and buttons get highlighted when an event is dragged over it. */
.vuecal__cell--highlighted:not(.vuecal__cell--has-splits),
.vuecal__cell-split--highlighted {background-color: rgba(195, 255, 225, 0.5);}
.vuecal__arrow.vuecal__arrow--highlighted,
.vuecal__view-btn.vuecal__view-btn--highlighted {background-color: rgba(136, 236, 191, 0.25);}
</style>
