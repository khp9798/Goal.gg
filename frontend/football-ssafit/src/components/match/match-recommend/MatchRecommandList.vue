<template>
    <div class="container">
        <h2>추천 매치 목록</h2>
        <div class="d-flex justify-content-start overflow-auto">
            <MatchRecommandListItem v-for="match in store.matchList" :match="match"/>
        </div>
    </div>
</template>

<script setup>
import { useMatchStore } from '@/stores/match';
import MatchRecommandListItem from './MatchRecommandListItem.vue';
import { onMounted } from 'vue';

const store =  useMatchStore()

onMounted(()=>{
    store.getMatchList()
})
</script>

<style lang="scss" scoped>

</style>