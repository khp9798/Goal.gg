<template>
    <div>
        <div>
            <img :src="imgUrl" alt="" width="100%">
        </div>
        
        {{ route.params.id }}번 매치의 디테일입니다.

        {{ store.match }}
    </div>
</template>

<script setup>
import { useMatchStore } from '@/stores/match';
import { onMounted } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute()

const store =  useMatchStore()

const imgUrl = "https://d31wz4d3hgve8q.cloudfront.net/media/dg_sj_coner_1.jpeg?w=1920"
onMounted(()=>{
    store.getMatch(route.params.id)
})
</script>

<style lang="scss" scoped>

</style>