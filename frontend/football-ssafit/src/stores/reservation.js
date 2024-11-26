import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
import { useUserStore } from './user'


const REST_RESERVATION_URL = "http://localhost:8080/reservations"
export const useReservationStore = defineStore('reservation', () => {
  const reservationList = ref([])

  const reservation = ref({})

  const matchManagerEvaluateList = ref([])



  const getList = function(userid){
    axios({
      url : REST_RESERVATION_URL,
      params : {userid : userid}
    })
    .then((response)=>{
      console.log(response.data)
      reservationList.value = response.data
    })
  }


  const getReservation = function(id){
    axios.get(REST_RESERVATION_URL+"/"+id)
    .then((response)=>{
      reservation.value = response.data
    })
  }

  const getMatchManagerEvaluateList = function(matchId){
    axios({
      url : REST_RESERVATION_URL+'/'+matchId+'/users',
      method : 'GET',
    }).then((res)=>{
      useravgstatList.value = []
      matchManagerEvaluateList.value = res.data
      
      matchManagerEvaluateList.value.forEach(element => {
        getavg(element.userId)

      });
      console.log(useravgstatList.value)
      console.log(usermatchstatList.value)
    }).catch((err)=>{
    })
  }

  let index = 0;
  const useravgstatList = ref([])
  const getavg = function(userId){
    axios({
      url: "http://localhost:8080/userstat" + "/avg",
      params: { userId },
    }).then((response)=>{
      // console.log(index++)
      useravgstatList.value[index++] = response.data
      // console.log(response)
    }).catch((err)=>{
      console.log(err)
    })
  }
  

  return { useravgstatList,getMatchManagerEvaluateList,matchManagerEvaluateList,reservationList,getList, reservation, getReservation }
})
