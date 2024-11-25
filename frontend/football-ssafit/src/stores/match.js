import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'
import { useUserStore } from './user'
import router from '@/router'


const REST_MATCH_API_URL = "http://localhost:8080/matches"
export const useMatchStore = defineStore('match', () => {
  const matchList = ref([])


  const match = ref({})

  const matchAvgTier = ref("")

  const stadiumMatchList = ref([]) // 해당 구장의 현재 매치

  const StadiumDayMatchList = ref([])

  const RecommandMatchList = ref([])

  const matchManagerList = ref([])

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




  const getMatch = async function(id){
    await axios.get(REST_MATCH_API_URL+"/"+id)
    .then((response)=>{
      match.value = response.data
    })
    .catch((err)=>{
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
   
  const getStadiumDayMatch = function(date1,date2, stadiumid){
    axios({
      url : REST_MATCH_API_URL+"/match/"+stadiumid+'/'+date1+'/'+date2
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
  // 매치 등록
  const registMatch = function(registmatch){
    axios({
      url : REST_MATCH_API_URL,
      method : 'POST',
      data : registmatch
    }).then((res)=>{
      alert("매치 등록에 성공했습니다")
      router.replace({name : 'home'})
    }).catch((err)=>{
      alert("매치 등록에 실패했습니다")
    })
  }

  const getMatchManagerList = function(managerid){
    axios({
      url : REST_MATCH_API_URL+'/manager',
      method : 'GET',
      params : {id : managerid}
    }).then((res)=>{
      matchManagerList.value = res.data
      console.log(matchManagerList.value)
    }).catch((err)=>{
    })
  }
  

  return { getMatchManagerList,matchManagerList, registMatch, StadiumDayMatchList,getStadiumDayMatch,matchList , match, getMatch, stadiumMatchList, getStadiumMatch,search, matchAvgTier, getMatchAvgTier, RecommandMatchList, getRecommandMatchList, getMatchRegionList,
    RegisterManager
   }

})
