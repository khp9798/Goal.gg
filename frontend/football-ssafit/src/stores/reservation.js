import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'


const REST_RESERVATION_URL = "http://localhost:8080/reservations"
export const useReservationStore = defineStore('reservation', () => {
  const reservationList = ref([])

  const reservation = ref({})


  const getList = function(){
    axios({
      url : REST_RESERVATION_URL,
      params : {userid : "ssafy"} //임시로 싸피넣음
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

  return { reservationList,getList, reservation, getReservation }
})
