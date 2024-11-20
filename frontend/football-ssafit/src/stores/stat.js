import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
const REST_STAT_API_URL = "http://localhost:8080/userstat"


export const useStatStore = defineStore('stat', () => {
  const userstatavg = ref({
    shoot: 0,
    pass: 0,
    speed: 0,
    stamina: 0,
    dribble: 0,
  });
  
  const getStat = async function(userId) {
    try {
      const res = await axios({
        url: REST_STAT_API_URL + "/avg",
        params: { userId },
      });
      console.log(res.data);
      userstatavg.value = res.data;
    } catch (error) {
      console.error("스탯 조회 실패:", error.response?.data || error.message);
      userstatavg.value = {}; // 에러 발생 시 초기화
    }
  };
  
  return {userstatavg, getStat }
})
