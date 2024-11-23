import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
import { useUserStore } from './user'


const REST_MATCH_API_URL = "http://localhost:8080/matches"
export const useMatchStore = defineStore('match', () => {
  const matchList = ref([])


  const match = ref({})

  const matchAvgTier = ref("")

  const stadiumMatchList = ref([]) // 해당 구장의 현재 매치

  const StadiumDayMatchList = ref([])

  const RecommandMatchList = ref([])

  const getMatchRegionList = function(region){
    axios({
      url: REST_MATCH_API_URL+"/search",
      params : {region:region}
    })
    .then((res)=>{
      matchList.value = res.data
    })
    .catch((err)=>{
      console.log("매치 리스트 가져오기 실패")
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

  const getStadiumMatch = function(stadiumid){
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
      console.log(response)
      StadiumDayMatchList.value = response.data
    })
  }


  const userstore = useUserStore()
  const getRecommandMatchList = function(district,province) {
    console.log(district)
    console.log(province)
    axios({
      url: REST_MATCH_API_URL + "/recommand",
      params: {
        district,
        province
      }
    }).then((res) => {
      if (res.status === 204) {
        console.log("추천 매치 없음");
        RecommandMatchList.value = []; // 빈 목록 처리
      } else {
        console.log("추천 매치 리스트:");
        console.log(res.data);
        RecommandMatchList.value = res.data;
      }
    }).catch((err) => {
      console.log("추천매치목록 가져오기 에러");
      console.log(err);
    });
  };


  //매니저등록
  const RegisterManager = function(match){
    axios({
      url : REST_MATCH_API_URL,
      method : 'put',
      data : match
    })
    .then((res)=>{
      console.log(res.data)
    })
    .catch((err)=>{
      console.log("매니저 등록 실패")
    })
  }
  

  return { StadiumDayMatchList,getStadiumDayMatch,matchList , match, getMatch, stadiumMatchList, getStadiumMatch,search, matchAvgTier, getMatchAvgTier, RecommandMatchList, getRecommandMatchList, getMatchRegionList,
    RegisterManager
   }

})
