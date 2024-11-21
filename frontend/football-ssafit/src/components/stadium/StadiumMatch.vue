<template>
    <tr>
        <td>{{ props.match.name }}</td>
        <td>{{ props.match.startTime }}</td>
        <td>{{ props.match.endTime }}</td>
        <td>{{ props.match.status }}</td>
    </tr>
</template>

<script setup>
import router from '@/router';
import { useMatchStore } from '@/stores/match';
import { useUserStore } from '@/stores/user';
import { onMounted } from 'vue';
const userstore = useUserStore()

const props = defineProps({
    match: Object
})
const goReservation = function () {
    router.push({ name: 'matchDetail', params: { id: props.match.id } })
}


</script>

<style lang="scss" scoped></style>