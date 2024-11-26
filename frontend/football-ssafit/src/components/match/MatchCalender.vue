<template>
    <div>
      <vue-cal
        style="height: 600px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);"
        :time-from="8 * 60"
        :time-to="24 * 60"
        active-view="month"
        :disable-views="['years', 'year', 'week']"
        locale="ko"
        :events="events"
        events-count-on-month-view
        @event-click="onEventClick"
      >
        <template #arrow-prev>
          <i class="icon material-icons" style="cursor: pointer;">&lt;</i>
        </template>
        <template #arrow-next>
          <i class="icon material-icons" style="cursor: pointer;">&gt;</i>
        </template>
      </vue-cal>
    </div>
  </template>
  
  <script setup>
  import VueCal from 'vue-cal';
  import 'vue-cal/dist/vuecal.css';
  import { ref, onMounted, watch } from 'vue';
  import { useMatchStore } from '@/stores/match';
  import router from '@/router';
  
  const props = defineProps({
    region: String
  });
  
  const matchStore = useMatchStore();
  const events = ref([]);
  
  onMounted(() => {
    matchStore.getMatchRegionList(props.region ?? '');
  });
  
  watch(
    () => matchStore.matchList,
    (newValue) => {
      if (newValue.length > 0) {
        events.value = newValue.map((item) => ({
          start: item.startTime.replace('T', ' ').slice(0, 16),
          end: item.endTime.replace('T', ' ').slice(0, 16),
          title: item.name,
          content: `${item.stadiumName} <span class="event-status">${item.status}</span>`,
          class: item.status === '신청 마감'
            ? 'status-closed'
            : item.status === '경기 취소'
            ? 'status-canceled'
            : item.status === '마감 임박'
            ? 'status-warning'
            : 'status-available',
          matchId: item.id
        }));
      } else {
        events.value = [];
      }
    }
  );
  
  const onEventClick = (event) => {
    router.push({ name: 'matchDetail', params: { id: event.matchId } });
  };
  </script>
  <style>
  /* 전반적인 카드 스타일 */
  .vuecal {
    border: 1px solid #ddd;
    background-color: #ffffff;
    border-radius: 12px;
    font-family: 'Inter', sans-serif;
  }
  
  /* 상태별 색상 */
  .status-available {
    background-color: #42b983 !important; /* 초록색 */
    color: white !important;
    font-weight: bold;
    border: 1px solid #3ca772;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(66, 185, 131, 0.4);
  }
  
  .status-warning {
    background-color: #ffc107 !important; /* 노란색 */
    color: black !important;
    font-weight: bold;
    border: 1px solid #e6a700;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(255, 193, 7, 0.4);
  }
  
  .status-canceled {
    background-color: #f44336 !important; /* 빨간색 */
    color: white !important;
    font-weight: bold;
    text-decoration: line-through;
    border: 1px solid #d32f2f;
    border-radius: 8px;
    opacity: 0.7;
    box-shadow: 0 2px 4px rgba(244, 67, 54, 0.4);
  }
  
  .status-closed {
    background-color: #9e9e9e !important; /* 회색 */
    color: white !important;
    font-weight: bold;
    border: 1px solid #757575;
    border-radius: 8px;
    opacity: 0.6;
    box-shadow: 0 2px 4px rgba(158, 158, 158, 0.4);
  }
  
  /* 달력 제목 바 */
  .vuecal__title-bar {
    background-color: #42b983;
    color: white ;
    border-radius: 12px 12px 0 0;
    padding: 10px 20px;
    font-size: 18px;
    font-weight: bold;
  }
  
  /* 달력 화살표 */
  .vuecal__arrow {
    background-color: #42b983;
    color: white;
    border-radius: 50%;
    padding: 8px;
    cursor: pointer;
  }
  
  .vuecal__arrow:hover {
    background-color: #3ca772;
  }
  
  /* 오늘 날짜 */
  .vuecal__cell--today {
    background-color: rgba(66, 185, 131, 0.1);
    border: 1px solid #42b983;
    font-weight: bold;
  }
  
  /* 이벤트에 마우스를 올렸을 때 효과 */
  .vuecal__event:hover {
    transform: scale(1.02);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15);
    transition: transform 0.2s, box-shadow 0.2s;
  }
  </style>