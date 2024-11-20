import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
const REST_STAT_API_URL = "http://localhost:8080/userstat"


export const useStatStore = defineStore('stat', () => {
  
  const userstatavg = ref({
  });

  const myKLeaguer = ref({})
  
  const getStat = async function(userId) {
    try {
      const res = await axios({
        url: REST_STAT_API_URL + "/avg",
        params: { userId },
      });
      // console.log(res.data);
      userstatavg.value = res.data;
    } catch (error) {
      // console.error("스탯 조회 실패:", error.response?.data || error.message);
      userstatavg.value = {}; // 에러 발생 시 초기화
    }
  };

  const getMyLeague = async function(userid){
    try{
      await axios({
        url: REST_STAT_API_URL+"/kleague",
        method : 'POST',
        params : {userId : userid}
      }).then((response)=>{
        // console.log("여기여기")
        myKLeaguer.value = response.data
        // console.log(myKLeaguer.value)
      }).catch((err)=>{
        // console.log("액시오스 실패")
        // console.log(err)
      })
    } catch (error){
      // console.log(error)
      // console.log("트라이캐치 실패")
    }
  }
  
  return {userstatavg, getStat,getMyLeague, myKLeaguer }
})
