<template>
    <div>
        홈뷰입니다.
        <!-- 유저뷰, 매치뷰 -->
        <UserItem/>
        <MatchRecommandList/>
    </div>
</template>

<script setup>

import MatchRecommandList from '@/components/match/match-recommend/MatchRecommandList.vue';
import UserItem from '@/components/user/UserItem.vue';

</script>

<style lang="scss" scoped>

</style>