<template>
    <div>
        <!-- 유저뷰, 매치뷰 -->
        <KakaoPay/>
        <UserItem/>
        <MatchRecommandList class="mt-5"/>
    </div>
</template>

<script setup>

import MatchRecommandList from '@/components/match/match-recommend/MatchRecommandList.vue';
import UserItem from '@/components/user/UserItem.vue';
import KakaoPay from '@/components/KakaoPay.vue';

</script>

<style lang="scss" scoped>

</style>