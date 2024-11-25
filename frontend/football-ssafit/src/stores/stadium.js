import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
import router from '@/router'
const REST_STADIUM_API_URL = "http://localhost:8080/stadium"


export const useStadiumStore = defineStore('stadium', () => {
  const stadiumlist = ref([])
  const stadium = ref({})

  function getStadiumList(){
    axios({
      url : REST_STADIUM_API_URL,
      method : "GET"
    }).then((response)=>{
      stadiumlist.value = response.data
    }).catch((err)=>{
    })
  }

  function getStadium(stadiumid){
    axios({
      url : REST_STADIUM_API_URL+'/'+stadiumid,
      method : "GET"
    }).then((response)=>{
      stadium.value = response.data
    }).catch((err)=>{
    })
  }


  function searchList(condition){
    axios({
      url : REST_STADIUM_API_URL+"/search",
      params : condition
    })
    .then((res)=>{
      stadiumlist.value = res.data
      console.log(stadiumlist.value)
      router.push({name:'stadiumlist'})
    })
    .catch((res)=>{
      stadiumlist.value = []
      router.push({name:'stadiumlist'})
    })
  }
  

  return {stadiumlist, stadium, getStadiumList,getStadium, searchList }
})
