<template>
    <div>
        유저 상세입니다.
        <div>
            사용자 아이디 : {{ userstore.loginUser.userid }}
        </div>
        <div>
            사용자 이름 : {{ userstore.loginUser.name }}
        </div>
    </div>
</template>

<script setup>
import { useUserStore } from '@/stores/user';
const userstore = useUserStore()


</script>

<style lang="scss" scoped></style>