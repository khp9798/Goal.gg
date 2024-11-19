import StadiumDetail from '@/components/stadium/StadiumDetail.vue'
import StadiumList from '@/components/stadium/StadiumList.vue'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'
import MatchView from '@/views/MatchView.vue'
import StadiumView from '@/views/StadiumView.vue'
import UserView from '@/views/UserView.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path : '/',
      name : 'homeview',
      component : HomeView
    },
    {
      path : '/user',
      name : 'userview',
      component : UserView
    },
    {
      path : '/match',
      name : 'matchview',
      component : MatchView
    },
    {
      path : '/stadium',
      name : 'stadiumview',
      component : StadiumView,
      // redirect : '/stadium/list',
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
      path : '/login',
      name : 'loginview',
      component : LoginView
    }
    
  ],
})

export default router
