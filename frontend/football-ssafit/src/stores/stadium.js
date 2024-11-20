import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
const REST_STADIUM_API_URL = "http://localhost:8080/stadium"


export const useStadiumStore = defineStore('stadium', () => {
  const stadiumlist = ref([])
  const stadium = ref({})

  function getStadiumList(){
    axios({
      url : REST_STADIUM_API_URL,
      method : "GET"
    }).then((response)=>{
      // console.log("성공")
      stadiumlist.value = response.data
      // console.log(response)
      // console.log(stadiumlist.value)
    }).catch((err)=>{
      // console.log("실패")
      // console.log(err)
    })
  }

  function getStadium(stadiumid){
    axios({
      url : REST_STADIUM_API_URL+'/'+stadiumid,
      method : "GET"
    }).then((response)=>{
      // console.log("성공")
      stadium.value = response.data
      // console.log(response)
    }).catch((err)=>{
      // console.log("실패")
      // console.log(err)
    })
  }
  

  return {stadiumlist, stadium, getStadiumList,getStadium,  }
})
