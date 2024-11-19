<template>
    <div>

        <RouterLink :to="{name:'home'}">logo</RouterLink> | 
        <RouterLink :to="{name:'match'}">매치 일정</RouterLink> | 
        
        <RouterLink :to="{name:'reservation'}">예약 확인</RouterLink>
    </div>
    <RouterView/>
</template>

<script setup>

</script>

<style lang="scss" scoped>

</style>