<template>
    <div class="container">
        <h2>추천 매치 목록</h2>
        <div class="d-flex justify-content-start overflow-auto">
            
            <template v-if="store.RecommandMatchList.length > 0 && isAute">
                <MatchRecommandListItem v-for="match in store.RecommandMatchList" :match="match" />
            </template>
            <template v-else-if="store.RecommandMatchList.length <=0 && isAute">
                <h4>주변에 진행되는 매치가 없습니다...</h4>
            </template>
            <template v-else>
                <MatchRecommandListItem v-for="match in store.matchList" :match="match" />
            </template>
        </div>
    </div>
</template>

<script setup>
import { useMatchStore } from '@/stores/match';
import MatchRecommandListItem from './MatchRecommandListItem.vue';
import { onMounted, onUpdated, ref } from 'vue';
import { useUserStore } from '@/stores/user';

const store = useMatchStore()

const userstore = useUserStore()

const isAute = ref(false);
onMounted(() => {
    if(!userstore.loginUser.userid){
        console.log("로그인안한거다!!")
        isAute.value = false;
        console.log(userstore.loginUser)
        store.getMatchList()
    }else{
        console.log("로그인한거다!!")
        isAute.value = true;
        store.getRecommandMatchList(userstore.loginUser.district, userstore.loginUser.province)
    }
})

</script>

<style lang="scss" scoped></style>