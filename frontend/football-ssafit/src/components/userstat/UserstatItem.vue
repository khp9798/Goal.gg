<template>
  <div class="row row-cols-md-2 row g-4 text-center">
    
      <div>
        <canvas ref="radarChart"></canvas>
      </div>
   
      <div class="image-container mx-auto">
        <div class="player-positionbox">
          <!-- <div class="player-rank">24</div> -->
          <div class="player-position" :class="positionColor"> {{ position }}</div>
        </div>
        <!-- Background Image -->
        <img src="/src/assets/Background/backgroundimg.png" alt="BackGround Image" class="background-img" />

        <!-- Season Badge -->
        <div class="d-flex season-img">
          <img src="/src/assets/Season/seasonimg.png" alt="Season Image">
          <span class="nameBold">&nbsp;{{ shortenedName || "아가 이강인" }}</span>
        </div>
        <!-- <img src="/src/assets/Season/seasonimg.png" alt="Season Image" class="season-img" > -->

        <img src="/src/assets/Flag/korea.jpg" alt="Flag Image" class="flag-img" />

        <img :src="`/src/assets/Team/${team}.png`" alt="Team Image" class="team-img" />

        <img src="/src/assets/logo.png" alt="GOAL.GG Image" class="logo-img" />


        <!-- Player Image -->
        <img :src="`/src/assets/PlayerImg/${playercode}.png`" alt="Player Image" class="player-img" />

        <!-- Player Info -->
        <div class="player-info">
          <!-- <div class="player-rank">24</div> -->
          <!-- <div class="player-name">{{ store.myKLeaguer.name }}</div> -->
        </div>
      </div>
  </div>

</template>
<script setup>
import { ref, onMounted, computed, onUpdated } from "vue";
import { Chart, registerables } from "chart.js";
import { useStatStore } from "@/stores/stat";
import { useUserStore } from "@/stores/user";
// Chart.js 플러그인 등록
Chart.register(...registerables);

const store = useStatStore();
const userStore = useUserStore();
const data = ref([]);
const targetdata = ref([]);

const position = computed(() => {
  if (userStore.loginUser.userid==undefined) {
    return "ST"; // 값이 있으면 그대로 반환
  } else if(store.myKLeaguer.position==undefined) {
    return "CAM"; // 값이 없으면 기본값 반환
  } else{
    return store.myKLeaguer.position
  }
});
const team = computed(() => {
  if (userStore.loginUser.userid==undefined) {
    return "토트넘"; // 값이 있으면 그대로 반환
  } else if(store.myKLeaguer.team==undefined) {
    return "김천 상무"; // 값이 없으면 기본값 반환
  } else{
    return store.myKLeaguer.team
  }
});
const playercode = computed(() => {
  if (userStore.loginUser.userid==undefined) {
    return 1; // 값이 있으면 그대로 반환
  } else if(store.myKLeaguer.team==undefined) {
    return 2; // 값이 없으면 기본값 반환
  } else{
    return store.myKLeaguer.playercode
  }
});


// `canvas`를 참조할 ref
const radarChart = ref(null);


const keys = ["shoot", "pass", "speed", "stamina", "dribble"];

const shortenedName = computed(() => {
  const name = store?.myKLeaguer?.name; // 안전하게 접근
  if (userStore.loginUser.userid==undefined) {
    return "손흥민"; // 이름이 없으면 빈 문자열 반환
  } else if(store.myKLeaguer.name==undefined){
    return "이강인"
  }
  return name.length > 7 ? name.slice(0, 7) + "..." : name; // 7글자 초과 시 잘라냄
});

onMounted(async () => {
  // 데이터 로드
  if (store.myKLeaguer.value == undefined || store.userstatavg.value == undefined) {
    console.log("hi")
    await store.getMyLeague(userStore.loginUser.userid);
    await store.getStat(userStore.loginUser.userid);
  }



  data.value = Object.keys(store.userstatavg)
    .filter(key => keys.includes(key)) // keys에 포함된 key만 필터링
    .map(key => store.userstatavg[key]);;
  targetdata.value = Object.keys(store.myKLeaguer)
    .filter(key => keys.includes(key)) // keys에 포함된 key만 필터링
    .map(key => store.myKLeaguer[key]); // 해당 key의 value를 가져옴

    // 로그인 안했을 때 스탯
  const UnloginedUser1 = ref([55,55,60,60,63])
  const UnloginedUser2 = ref([70,65,60,65,70])

  // `radarChart` ref를 통해 DOM에 접근
  if (radarChart.value) {
    const ctx = radarChart.value.getContext("2d");
    new Chart(ctx, {
      type: "radar",
      data: {
        labels: ["슛", "패스", "속력", "체력", "드리블"],
        datasets: [
          {
            label: userStore.loginUser.name!= undefined ? userStore.loginUser.name+" 능력치" : "김싸피 능력치",
            data: data.value.length > 0 ? data.value : UnloginedUser1.value,
            backgroundColor: "rgba(0, 128, 255, 0.4)",
            pointBackgroundColor: "black",
          },
          {
            label: store.myKLeaguer.name!= undefined ? store.myKLeaguer.name + " 능력치" : "손흥민 능력치",
            data: targetdata.value.length > 0 ? targetdata.value : UnloginedUser2.value,
            backgroundColor: "rgba(128,0,0, 0.4)",
            pointBackgroundColor: "black",
          },
        ],
      },
      options: {
        animation: {
          duration: 1000,
          easing: "easeOutBounce",
        },
        responsive: false,
        scales: {
          r: {
            angleLines: { display: true },
            suggestedMin: 0,
            suggestedMax: 100,
          },
        },
      },
    });
  }
});

const positionColor = computed(() => {
  const position = store.myKLeaguer.position
  if (['CM', 'CAM', 'CDM', 'LM','RM'].includes(position)) {
    return "midfield"
  } else if (['RB', 'LB', 'CB', 'RWB', 'LWB'].includes(position)) {
    return "defense"
  } else if (position === 'GK') {
    return "goalkeeper"
  } else {
    return "forward"
  }


})



</script>

<style scoped>
canvas {
  max-width: 100%;
  margin: auto;
}

.image-container {
  position: relative;
  text-align: center;
  width: 180px;
  height: 280px;
  display: flex;
  align-items: center;
  justify-content: center;
  justify-items: center;
}

/* Background Image */
.background-img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

/* Season Badge */
.season-img {
  position: absolute;
  top: 205px;
  left: 0;
  width: 100%;
  height: auto;
  z-index: 2;
  display: flex;
  justify-content: center; /* 수평 가운데 정렬 */
  align-items: center; /* 수직 가운데 정렬 */
  white-space: nowrap; /* 텍스트 줄바꿈 방지 */
  overflow: hidden; /* 넘치는 텍스트 숨기기 */
  text-overflow: ellipsis; /* 넘칠 때 '...' 표시 */
  padding : 0 10px; /* 양쪽 여백 추가 (필요하면 조정) */
  box-sizing: border-box; /* 패딩 포함 크기 계산 */

}


.flag-img {
  position: absolute;
  top: 100px;
  left: 15px;
  width: 35px;
  height: 22px;
  z-index: 2;
}

.logo-img {
  position: absolute;
  top: 20px;
  left: 60px;
  width: 55px;
  height: 50px;
  z-index: 2;
  opacity: 0.6;
}

.team-img {
  position: absolute;
  bottom: 10px;
  left: 68px;
  width: 43px;
  height: 43px;
  z-index: 2;
}


/* Player Image */
.player-img {
  position: absolute;
  top: 70px;
  left: 25px;
  width: 130px;
  height: 130px;
  z-index: 3;
}

/* Player Info */
.player-info {
  position: absolute;
  bottom: 50px;
  left: 18px;
  width: 100%;
  text-align: center;
  z-index: 4;
}

.player-name {
  font-size: 18px;
  color: black;
  font-weight: 900;
}

.player-positionbox {
  position: absolute;
  top: 70px;
  right: 60px;
  width: 100%;
  text-align: center;
  z-index: 4;
}

.player-position {
  font-size: 18px;
  font-weight: 900;
}

.forward {
  color: rgb(215, 22, 22);
}

.midfield {
  color: rgb(12, 214, 80);
}

.defense {
  color: rgb(41, 113, 245);
}

.goalkeeper {
  color: rgb(210, 210, 11)
}

.nameBold{
  font-weight: 900;
}
</style>
