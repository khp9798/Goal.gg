<template>
    <div>
        <!-- 유저뷰, 매치뷰 -->
        <video width="640" height="360" controls autoplay muted>
  <source src="../assets/395e841484a8de4e4b32581ade78513f.mp4" type="video/mp4">
  브라우저가 비디오 태그를 지원하지 않습니다.
</video>

        <UserItem/>
        <MatchRecommandList class="mt-5"/>
    </div>
</template>

<script setup>

import MatchRecommandList from '@/components/match/match-recommend/MatchRecommandList.vue';
import UserItem from '@/components/user/UserItem.vue';

</script>

<style lang="scss" scoped>

</style>