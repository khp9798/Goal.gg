<template>
    <div>
        유저뷰입니다.
        <!-- 유저 뷰 안에 유저 컴포넌트랑 유저 스탯 컴포넌트 둘다 추가 -->
        <UserDetail/>
        <UserstatItem/>
    </div>
</template>

<script setup>
import UserDetail from '@/components/user/UserDetail.vue';
import UserstatItem from '@/components/userstat/UserstatItem.vue';


</script>

<style lang="scss" scoped>

</style>