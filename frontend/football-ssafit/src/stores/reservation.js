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
      matchManagerEvaluateList.value = res.data
    }).catch((err)=>{
    })
  }

  

  return { getMatchManagerEvaluateList,matchManagerEvaluateList,reservationList,getList, reservation, getReservation }
})
