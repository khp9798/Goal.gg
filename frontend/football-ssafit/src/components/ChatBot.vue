<template>
    <div>
      <!-- 챗봇 아이콘 -->
      <div class="chatbot-icon" @click="toggleChat">
        <img src="/src/assets/logo.png" alt="Chatbot Icon" />
      </div>
  
      <!-- 대화창 -->
      <div v-if="isChatOpen" class="chatbot-container">
        <div class="chatbot-header">
          <h3>Goal.GG ChatBot</h3>
          <button class="close-button" @click="toggleChat">X</button>
        </div>
        <div class="chatbot-messages">
          <div v-for="(message, index) in messages" :key="index" class="message">
            <strong class="role">{{ message.role === 'user' ? 'You' : 'Bot' }}:</strong>
            <p v-if="message.role === 'bot'" class="bot-response">{{ message.content }}</p>
            <p v-else>{{ message.content }}</p>
          </div>
        </div>
        <textarea
          v-model="userMessage"
          class="chatbot-input"
          placeholder="Type your message..."
        ></textarea>
        <button @click="sendMessage" class="send-button">Send</button>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from "vue";
  import { fetchChatGPTResponse } from "../api/openai";
  
  // 상태 변수
  const isChatOpen = ref(false); // 대화창 열림/닫힘 상태
  const userMessage = ref(""); // 사용자 입력 메시지
  const messages = ref([]); // 메시지 목록
  
  // 대화창 열기/닫기
  const toggleChat = () => {
    isChatOpen.value = !isChatOpen.value;
  };
  
  // 메시지 전송
  const sendMessage = async () => {
    if (userMessage.value.trim() === "") return;
    messages.value.push({ role: "user", content: userMessage.value }); // 사용자 메시지 추가
    try {
      const response = await fetchChatGPTResponse(userMessage.value); // OpenAI API 호출
      messages.value.push({ role: "bot", content: response }); // 챗봇 응답 추가
    } catch (error) {
      console.error("Error sending message:", error);
      messages.value.push({
        role: "bot",
        content: "Sorry, something went wrong.",
      });
    } finally {
      userMessage.value = ""; // 입력창 초기화
    }
  };
  </script>
  
  <style scoped>
  /* 챗봇 아이콘 */
  .chatbot-icon {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background-color: #000; /* 검은색 배경 */
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  
  .chatbot-icon img {
    width: 30px;
    height: 30px;
  }
  
  /* 대화창 */
  .chatbot-container {
    position: fixed;
    bottom: 80px;
    right: 20px;
    width: 350px;
    background-color: #000; /* 검은색 배경 */
    border: 1px solid #333; /* 약간의 테두리 */
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.5);
    display: flex;
    flex-direction: column;
    overflow: hidden;
    font-family: Arial, sans-serif;
    z-index: 1000;
  }
  
  /* 대화창 헤더 */
  .chatbot-header {
    background-color: #000; /* 검은색 배경 */
    color: white; /* 흰색 텍스트 */
    padding: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .close-button {
    background: none;
    border: none;
    color: white; /* 흰색 텍스트 */
    font-size: 16px;
    cursor: pointer;
  }
  
  /* 대화 메시지 */
  .chatbot-messages {
    padding: 10px;
    max-height: 300px;
    overflow-y: auto;
    flex: 1;
    color: white; /* 메시지 텍스트 흰색 */
  }
  
  .message {
    margin-bottom: 10px;
  }
  
  .message .role {
    font-weight: bold;
    color: #ff4500; /* 사용자 이름은 주황색 포인트 */
  }
  
  .bot-response {
    margin: 5px 0;
    line-height: 1.5; /* 가독성을 위한 줄 간격 */
    white-space: pre-wrap;
  }
  
  /* 입력창 */
  .chatbot-input {
    width: calc(100% - 20px);
    margin: 10px;
    padding: 10px;
    border: 1px solid #333; /* 검은색 테두리 */
    border-radius: 4px;
    font-size: 14px;
    background-color: #222; /* 어두운 회색 배경 */
    color: white; /* 흰색 텍스트 */
  }
  
  /* 전송 버튼 */
  .send-button {
    margin: 10px;
    padding: 10px;
    background-color: #333; /* 어두운 회색 배경 */
    color: white; /* 흰색 텍스트 */
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
  }
  
  .send-button:hover {
    background-color: #555; /* 조금 더 밝은 회색 */
  }
  </style>
