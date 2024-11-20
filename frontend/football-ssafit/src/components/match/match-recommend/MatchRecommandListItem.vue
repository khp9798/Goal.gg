<template>
    <div class="card mx-3 flex-shrink-0" style="width: 25rem;">
        <img :src="props.match.image" class="card-img-top" alt="..." width="300" height="200">
        <div class="card-body text-center">
            <h5 class="card-title">{{props.match.name}}</h5>
            <p class="card-text">{{ props.match.stadiumName }}</p>
            
        </div>
    </div>
</template>

<script setup>


const props = defineProps({
    match: Object
})
</script>

<style lang="scss" scoped></style>