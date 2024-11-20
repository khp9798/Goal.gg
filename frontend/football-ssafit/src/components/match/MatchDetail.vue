<template>
    <div class="container">
        <div class="card mb-3">
            <img :src="store.match.image" class="card-img-top" alt="...">
            <div class="card-body">
                <h5 class="card-title">Card title</h5>
                <p class="card-text">{{ store.match }}</p>
            </div>
        </div>
    </div>

</template>

<script setup>
import { useMatchStore } from '@/stores/match';
import { onMounted } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute()

const store = useMatchStore()

onMounted(() => {
    store.getMatch(route.params.id)
})
</script>

<style lang="scss" scoped></style>