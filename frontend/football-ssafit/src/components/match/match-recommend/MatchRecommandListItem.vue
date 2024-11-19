<template>
    <div class="card mx-3 flex-shrink-0" style="width: 25rem;">
        <img :src="tmpimgUrl" class="card-img-top" alt="...">
        <div class="card-body text-center">
            <h5 class="card-title">{{props.match.name}}</h5>
            <p class="card-text">{{ props.match.stadiumName }}</p>
        </div>
    </div>
</template>

<script setup>
const tmpimgUrl = "https://d31wz4d3hgve8q.cloudfront.net/media/dg_sj_coner_1.jpeg?w=1920"

const props = defineProps({
    match: Object
})
</script>

<style lang="scss" scoped></style>