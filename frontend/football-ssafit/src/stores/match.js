import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'


const REST_MATCH_API_URL = "http://localhost:8080/matches"
export const useMatchStore = defineStore('match', () => {
  const matchList = ref([])

  
  const match = ref({})

  const getMatchList = function(){
    axios.get(REST_MATCH_API_URL)
    .then((response)=>{
      matchList.value = response.data
    })
  }


  const getMatch = function(id){
    axios.get(REST_MATCH_API_URL+"/"+id)
    .then((response)=>{
      match.value = response.data
    })
    .catch((err)=>{
      console.log(err.response.data)
    })
  }


  const search = function(condition){
    axios({
      url : REST_MATCH_API_URL+"/search",
      params : condition
    }).then((res)=>{
      console.log(res)
    })
  }
  return { matchList,getMatchList , match, getMatch,search }
})
