import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'


const REST_MATCH_API_URL = "http://localhost:8080/matches"
export const useMatchStore = defineStore('match', () => {
  const matchList = ref([])

  const getMatchList = function(){
    axios.get(REST_MATCH_API_URL)
    .then((response)=>{
      matchList.value = response.data
    })
  }

  return { matchList,getMatchList }
})
