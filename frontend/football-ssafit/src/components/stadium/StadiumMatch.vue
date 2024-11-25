<template>
    <tr @click="goReservation">
        <td>{{ props.match.name }}</td>
        <td>{{ props.match.startTime.replace('T', ' ').slice(0, 16) }}</td>
        <td>{{ props.match.endTime.replace('T', ' ').slice(0, 16) }}</td>
        <td :class="props.match.status">{{ props.match.status }}</td>
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

<style scoped>
.마감 {
    color : rgb(72, 72, 72);
    font-weight: bold;
}
.취소{
    color : rgb(72, 72, 72);
    font-weight: bold;
}
.가능{
    color : rgb(44, 111, 255);
    font-weight: bold;
}
.임박{
    color : red;
    font-weight: bold;
}
</style>