<template>
    <div class="container">
        <h2>추천 매치 목록</h2>
        <div class="d-flex justify-content-start overflow-auto">
            <template v-if="store.RecommandMatchList.length <= 0">
                <MatchRecommandListItem v-for="match in store.matchList" :match="match" />
            </template>
            <template v-else>
                <MatchRecommandListItem v-for="match in store.RecommandMatchList" :match="match" />
            </template>
        </div>
    </div>
</template>

<script setup>
import { useMatchStore } from '@/stores/match';
import MatchRecommandListItem from './MatchRecommandListItem.vue';
import { onMounted, onUpdated } from 'vue';
import { useUserStore } from '@/stores/user';

const store = useMatchStore()

const userstore = useUserStore()
onMounted(() => {
    if(!userstore.loginUser.userid){
        console.log("로그인안한거다!!")
        console.log(userstore.loginUser)
        store.getMatchList()
    }else{
        console.log("로그인한거다!!")
        store.getRecommandMatchList(userstore.loginUser.district, userstore.loginUser.province)
    }
})

</script>

<style lang="scss" scoped></style>