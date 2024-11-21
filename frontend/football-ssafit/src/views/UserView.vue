<template>
    <div class="container">
        <h2 class="pb-2 border-bottom">마이페이지</h2>
        <!-- 유저 뷰 안에 유저 컴포넌트랑 유저 스탯 컴포넌트 둘다 추가 -->
        <template v-if="userstore.loginUser.userid">
            <UserstatItem />
            <UserstatChart />
            <UserDetail />
        </template>
    </div>
</template>

<script setup>
import UserDetail from '@/components/user/UserDetail.vue';
import UserstatChart from '@/components/userstat/UserstatChart.vue';
import UserstatItem from '@/components/userstat/UserstatItem.vue';
import router from '@/router';
import { useUserStore } from '@/stores/user';
import { onBeforeMount } from 'vue';
const userstore = useUserStore()


onBeforeMount(()=>{
    console.log("유저뷰에서 마운트되기 전입니다.")
    if(!userstore.loginUser.userid){
        window.alert("로그인이 필요합니다")
        router.push({name : 'loginview'})
    }
})


</script>

<style lang="scss" scoped>

</style>