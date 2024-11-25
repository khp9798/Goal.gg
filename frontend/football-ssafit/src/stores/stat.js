import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
const REST_STAT_API_URL = "http://localhost:8080/userstat"


export const useStatStore = defineStore('stat', () => {
  
  const userstatavg = ref({
  });

  const userstatList = ref([])

  const myKLeaguer = ref({})

  const user1 = ref({})
  const user2 = ref({})
  const user3 = ref({})
  const user4 = ref({})
  const user5 = ref({})
  const user6 = ref({})
  const user7 = ref({})
  const user8 = ref({})
  const user9 = ref({})
  const user10 = ref({})
  const user11 = ref({})
  const user12 = ref({})
  const user13 = ref({})
  const user14 = ref({})
  const user15 = ref({})
  const user16 = ref({})
  const user17 = ref({})
  const user18 = ref({})


  
  const getStat = async function(userId) {
    try {
      const res = await axios({
        url: REST_STAT_API_URL + "/avg",
        params: { userId },
      });
      userstatavg.value = res.data;
    } catch (error) {
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
        myKLeaguer.value = response.data
        console.log("mykleague")
        console.log(myKLeaguer.value)
      }).catch((err)=>{
      })
    } catch (error){
      
    }
  }
  
  const getStatList = function(userId){
    try{
      axios({
        url: REST_STAT_API_URL,
        params : {userId}
      })
      .then((res)=>{
        userstatList.value = res.data
        console.log(userstatList.value)
      })
      .catch((err)=>{
        console.log(err)
      })
    } catch(err){

    }
    
  }

  const registUserStat = function(userstat){
    try{
      axios({
        url: REST_STAT_API_URL,
        method : "POST",
        data : userstat
      })
      .then((res)=>{
        console.log("성공")
      })
      .catch((err)=>{
        console.log("실패")

      })
    } catch(err){

    }
  }




  return {registUserStat,userstatavg, getStat,getMyLeague, myKLeaguer, userstatList,getStatList, user1,user2,user3,user4,user5,user6,user7,user8,user9,user10,user11,user12,user13,user14,user15,user16,user17,user18 }
})
