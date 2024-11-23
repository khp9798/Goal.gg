<template>
    <div class="container mt-5">
        <h2 class="mb-4">경기장 목록</h2>

        <div v-if="stadiumstore.stadiumlist.length > 0" class="row g-4">
            <div
                v-for="stadium in stadiumstore.stadiumlist"
                :key="stadium.id"
                class="col-md-6"
            >
                <StadiumListItem :stadium="stadium" />
            </div>
        </div>

        <div v-else class="text-center mt-5">
            <h2 class="text-muted">검색된 결과가 없습니다..</h2>
        </div>
    </div>
</template>

<script setup>
import { useStadiumStore } from "@/stores/stadium";
import StadiumListItem from "./StadiumListItem.vue";
import { onMounted } from "vue";


const stadiumstore = useStadiumStore();

onMounted(() => {
    if (stadiumstore.stadiumlist.length === 0) {
        stadiumstore.getStadiumList();
    }
});
</script>

<style scoped>
h2 {
    font-weight: bold;
    color: #343a40;
}

.text-muted {
    color: #6c757d !important;
}
</style>
