<template>

    <div class="card mx-3 flex-shrink-0" style="width: 25rem;">
        <div class="card-body text-center"  @click="goReservation">
            <h5 class="card-title">{{props.match.name}}</h5>
            <p class="card-text">{{ props.match.stadiumName }}</p>
            <p class="card-text">{{ props.match.startTime }}</p>
            <p class="card-text">{{ props.match.endTime }}</p>
            <p class="card-text">{{ props.match.capacity }}</p>
            <p class="card-text">{{ props.match.status }}</p>

        </div>
    </div>
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
const goReservation = function(){
    router.push({name: 'matchDetail', params : {id : props.match.id}})
}


</script>

<style lang="scss" scoped>

</style>