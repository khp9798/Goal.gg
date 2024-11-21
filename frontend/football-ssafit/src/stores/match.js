import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'


const REST_MATCH_API_URL = "http://localhost:8080/matches"
export const useMatchStore = defineStore('match', () => {
  const matchList = ref([])


  const match = ref({})

  const matchAvgTier = ref("")

  const stadiumMatchList = ref([]) // 해당 구장의 현재 매치

  const StadiumDayMatchList = ref([])

  const getMatchList = function(){
    axios.get(REST_MATCH_API_URL)
    .then((response)=>{
      matchList.value = response.data
    })
    .catch((err)=>{
      console.log(err.data)
    })
  }


  const getMatch = function(id){
    axios.get(REST_MATCH_API_URL+"/"+id)
    .then((response)=>{
      match.value = response.data
      console.log(match)
    })
    .catch((err)=>{
      console.log(err.response.data)
    })
  }

  const getStadiumMatch = function(stadiumid){
    // console.log(stadiumid)
    // console.log("여기에요 여기")
    axios({
      url : REST_MATCH_API_URL+'/match/'+stadiumid,
      method : 'GET'
    }).then((response)=>{
      stadiumMatchList.value = response.data
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


  const getMatchAvgTier = function(matchId){
    axios({
      url : REST_MATCH_API_URL+"/tier/"+matchId
    })
    .then((res)=>{
      matchAvgTier.value = res.data
    })
  }
   
  const getStadiumDayMatch = function(date, stadiumid){
    axios({
      url : REST_MATCH_API_URL+"/match/"+stadiumid+'/'+date
    }).then((response)=>{
      console.log("여기여기")
      console.log(response)
      StadiumDayMatchList.value = response.data
    })
  }

  return { StadiumDayMatchList,getStadiumDayMatch,matchList,getMatchList , match, getMatch, stadiumMatchList, getStadiumMatch,search, matchAvgTier, getMatchAvgTier }

})
