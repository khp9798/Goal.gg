import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios' // axios 임포트
import router from '@/router'
import { useStatStore } from './stat'
const REST_USER_API = 'http://localhost:8080/users' //user API 주소
const REST_USERSTAT_API = 'http://localhost:8080/userstat' 


export const useUserStore = defineStore('user', () => {
  const loginUser = ref({}) // 현재 로그인 되어있는 유저

  const loginUserStat = ref({
  })

  const tryLogin = function(tryLoginUser){ // 유저 로그인
    axios({
      url : REST_USER_API+'/login',
      method : "POST",
      data : tryLoginUser
    }).then((response)=>{
      console.log("로그인 성공")
      console.log(response)
      loginUser.value = response.data // 현재 로그인 된 유저 아이디 업데이트
      router.replace({name : 'home'}) // 로그인 성공 시 홈으로(뒤로가기로?)
    }).catch((err)=>{
      console.log("로그인 실패")
      console.log(err)
      window.alert("아이디 혹은 비밀번호를 확인하세요")
    })
  }

  const statStore = useStatStore()
  const tryLogout = function(){
    loginUser.value ={}
    statStore.userstatavg = {}
    statStore.myKLeaguer = {}
    console.log("로그아웃 성공")
    router.replace({name:'home'})
  }

  const trySignup = function(trySignupUser){ // 회원가입
    console.log(trySignupUser)
    axios({
      url : REST_USER_API+'/regist',
      method : "POST",
      data : trySignupUser
    }).then((response)=>{
      console.log("회원가입 성공")
      console.log(response)
      router.replace({name : 'home'}) // 로그인 성공 시 홈으로(뒤로가기로?)
    }).catch((err)=>{
      console.log("회원가입 실패")
      console.log(err)
      window.alert("회원가입 실패했습니다")
    })
  }

  const getUserstat = function(userid){
    axios({
      url : REST_USERSTAT_API+'/avg',
      method : 'GET',
      params : {userId : userid}
    }).then((response)=>{
      console.log("성공")
      console.log(response)
      loginUserStat.value = response.data
    }).catch((err)=>{
      console.log(err)
    })


  }
  

  return {loginUser, tryLogin, tryLogout, trySignup, getUserstat, loginUserStat   }
})
