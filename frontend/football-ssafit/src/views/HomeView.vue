<template>
    <div>
        <div>
            <h1>ChatGPT Demo</h1>
            <textarea v-model="userMessage" placeholder="Type your message..."></textarea>
            <button @click="sendMessage">Send</button>
            <div v-if="responseMessage">
                <h3>ChatGPT Response:</h3>
                <p>{{ responseMessage }}</p>
            </div>
        </div>





        <UserItem />
        <MatchRecommandList class="mt-5" />
    </div>
</template>

<script setup>

import MatchRecommandList from '@/components/match/match-recommend/MatchRecommandList.vue';
import UserItem from '@/components/user/UserItem.vue';

import { ref } from 'vue';
import { fetchChatGPTResponse } from '../api/openai';

const userMessage = ref('');
const responseMessage = ref('');

const sendMessage = async () => {
    try {
        responseMessage.value = await fetchChatGPTResponse(userMessage.value);
    } catch (error) {
        console.error(error.message);
        responseMessage.value = 'Error: Unable to get a response.';
    }
};

</script>

<style scoped></style>