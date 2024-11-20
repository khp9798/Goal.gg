<template>
    <div>
        스타디움별 매치입니다
        {{ props.stadiumid }}
        <!-- {{ matchstore.stadiumMatchList }} -->
        <hr>
        <div v-for="match in matchstore.stadiumMatchList" >
            <ul>
                <li>match id : {{match.id}}</li>
                <li>match name :{{ match.name }}</li>
                <li>match stadiumId : {{ match.stadiumId }}</li>
                <li>match.stadiumName :{{ match.stadiumName }}</li>
                <li>match.startTime :{{ match.startTime }}</li>
                <li>match.endTime :{{ match.endTime }}</li>
                <li>match.status :{{ match.status }}</li>
            </ul>
        </div>
    </div>
</template>

<script setup>
import { useMatchStore } from '@/stores/match';
import { onMounted } from 'vue';

const props = defineProps({
    stadiumid : Number
})
const matchstore = useMatchStore()

onMounted(()=>{
    matchstore.getStadiumMatch(props.stadiumid)
})


</script>

<style lang="scss" scoped>

</style>