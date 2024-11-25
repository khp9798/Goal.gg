import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
const REST_STAT_API_URL = "http://localhost:8080/userstat"


export const useStatStore = defineStore('stat', () => {
  
  const userstatavg = ref({
  });

  const userstatList = ref([])

  const myKLeaguer = ref({})
  
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




  return {userstatavg, getStat,getMyLeague, myKLeaguer, userstatList,getStatList, }
})
