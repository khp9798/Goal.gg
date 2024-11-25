import StadiumDetail from '@/components/stadium/StadiumDetail.vue'
import LoginView from '@/views/LoginView.vue'
import MatchView from '@/views/MatchView.vue'
import UserView from '@/views/UserView.vue'
import MatchDetail from '@/components/match/MatchDetail.vue'
import HomeView from '@/views/HomeView.vue'
import ReservationView from '@/views/ReservationView.vue'
import { createRouter, createWebHistory } from 'vue-router'
import SignupView from '@/views/SignupView.vue'
import StadiumView from '@/views/StadiumVIew.vue'
import StadiumList from '@/components/stadium/StadiumLIst.vue'
import StadiumMatch from '@/components/stadium/StadiumMatch.vue'
import ReservationForm from '@/components/reservation/ReservationForm.vue'
import MatchRegistForm from '@/components/match/MatchRegistForm.vue'
import ReservationSuccess from '@/components/reservation/ReservationSuccess.vue'
import MatchManager from '@/components/match/MatchManagerList.vue'
import MatchManagerView from '@/views/MatchManagerView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path : '/user',
      name : 'userview',
      component : UserView
    },
    {
      path : '/stadium',
      name : 'stadiumview',
      component : StadiumView,
      children : [
        {
          path : '',
          name : 'stadiumlist',
          component : StadiumList
        }
      ]
    },
    {
      path: '/stadium/:id',
      name : 'stadiumdetail',
      component : StadiumDetail
    },
    {
      path : '/stadium/match/:id',
      name : 'stadiummatch',
      component : StadiumMatch
    },
    {
      path : '/login',
      name : 'loginview',
      component : LoginView
    },
    {
      path: '/',
      name : 'home',
      component : HomeView
    },
    {
      path : '/match',
      name : 'match',
      component : MatchView,
      
    },
    {
      path : '/match/:id',
      name : 'matchDetail',
      component : MatchDetail
    },
    {
      path : '/reservation',
      name : 'reservation',
      component : ReservationView
    },
    {
      path : '/reservation/:id/success',
      name : 'reservationDone',
      component : ReservationSuccess
    },
    {
      path : '/signup',
      name : 'signup',
      component : SignupView
    },
    {
      path : '/reservationform',
      name : 'reservationform',
      component : ReservationForm
    },
    {
      path : '/matchresgistform',
      name : 'matchregistform',
      component : MatchRegistForm
    },
    {
      path : '/matchmanagerview',
      name : 'matchmanagerview',
      component : MatchManagerView
    }
  ],
})

export default router
