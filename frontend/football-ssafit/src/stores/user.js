import { ref } from 'vue';
import { defineStore } from 'pinia';
import axios from 'axios'; // axios 임포트
import router from '@/router';
import { useStatStore } from './stat';

const REST_USER_API = 'http://localhost:8080/users'; // user API 주소
const REST_USERSTAT_API = 'http://localhost:8080/userstat';

export const useUserStore = defineStore('user', () => {
  // 상태
  const loginUser = ref(JSON.parse(sessionStorage.getItem('loginUser')) || {}); // 현재 로그인된 유저
  const loginUserStat = ref({});
  const isManagerMode = ref(false);
  const isAuth = ref(!!loginUser.value); // 로그인 상태 확인

  // 액션: 로그인
  const tryLogin = async (tryLoginUser) => {
    try {
      const response = await axios.post(`${REST_USER_API}/login`, tryLoginUser);
      console.log('로그인 성공');
      loginUser.value = response.data; // 현재 로그인된 유저 업데이트
      isAuth.value = true;
      sessionStorage.setItem('loginUser', JSON.stringify(loginUser.value)); // 세션 스토리지에 저장
      console.log(loginUser.value)
      router.replace({ name: 'home' }); // 로그인 성공 시 홈으로 이동
    } catch (err) {
      console.log('로그인 실패');
      console.error(err);
      window.alert('아이디 혹은 비밀번호를 확인하세요');
    }
  };

  // 액션: 로그아웃
  const tryLogout = () => {
    const statStore = useStatStore();
    loginUser.value = {};
    sessionStorage.removeItem('loginUser'); // 세션 스토리지에서 제거
    statStore.userstatavg = {};
    statStore.myKLeaguer = {};
    isManagerMode.value = false;
    isAuth.value = false;
    console.log('로그아웃 성공');
    router.replace({ name: 'home' });
  };

  // 액션: 회원가입
  const trySignup = async (trySignupUser) => {
    try {
      const response = await axios.post(`${REST_USER_API}/regist`, trySignupUser);
      console.log('회원가입 성공');
      console.log(response);
      router.replace({ name: 'loginview' }); // 회원가입 후 로그인 페이지로 이동
    } catch (err) {
      console.log('회원가입 실패');
      console.error(err);
      window.alert('아이디가 중복되었습니다.');
    }
  };

  // 액션: 유저 통계 가져오기
  const getUserstat = async (userid) => {
    try {
      const response = await axios.get(`${REST_USERSTAT_API}/avg`, {
        params: { userId: userid },
      });
      console.log('유저 통계 가져오기 성공');
      loginUserStat.value = response.data;
    } catch (err) {
      console.error('유저 통계 가져오기 실패', err);
    }
  };

  // 반환: 상태와 액션
  return {
    loginUser,
    loginUserStat,
    isManagerMode,
    isAuth,
    tryLogin,
    tryLogout,
    trySignup,
    getUserstat,
  };
});
