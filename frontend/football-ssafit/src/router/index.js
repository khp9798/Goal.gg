import MatchDetail from '@/components/match/MatchDetail.vue'
import MatchList from '@/components/match/MatchList.vue'
import ReservationDetail from '@/components/reservation/ReservationDetail.vue'
import HomeView from '@/views/HomeView.vue'
import MatchView from '@/views/MatchView.vue'
import ReservationView from '@/views/ReservationView.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name : 'home',
      component : HomeView
    },
    {
      path : '/match',
      name : 'match',
      component : MatchView
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
      path : '/reservation/:id',
      name : 'reservationDetail',
      component : ReservationDetail
    }
    
  ],
})

export default router
