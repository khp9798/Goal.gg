import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
import { useUserStore } from './user'
import { useMatchStore } from './match'


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
      index = 0;
      console.log(useravgstatList.value)
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
      useravgstatList.value[index++] = response.data
      console.log("useravgstatlist")
      console.log(useravgstatList.value)
    }).catch((err)=>{
      console.log(err)
    })
  }



  const matchstore = useMatchStore()
  const isParticipate = function(userId, matchId){
    axios({
      url : REST_RESERVATION_URL+"/check",
      method : 'post',
      params : {userId,matchId}
    })
    .then((res)=>{
      console.log(res.data)
      matchstore.match.isParticipate = false;
    })
    .catch((err)=>{
      console.log(err)
      matchstore.match.isParticipate = true;
    })

  }


  const cancelReservation = function(userId, matchId){
    axios({
      url : REST_RESERVATION_URL+"/cancel",
      method : 'delete',
      params : {userId, matchId}
    })
    .then((res)=>{
      console.log(res.data)
      alert("예약이 정상적으로 취소 되었습니다.")
    })
    .catch((err)=>{
      console.log(err)
    })
  }



  

  return { useravgstatList,getMatchManagerEvaluateList,matchManagerEvaluateList,reservationList,getList, reservation, getReservation, isParticipate,cancelReservation }
})
