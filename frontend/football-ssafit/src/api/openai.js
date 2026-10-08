import axios from 'axios';

export const fetchChatGPTResponse = async (message) => {
  try {
    const response = await axios.post('http://localhost:8080/api/chat', { message });
    return response.data.message;
  } catch (error) {
    console.error('Error fetching response:', error);
    throw new Error('Failed to fetch ChatGPT response');
  }
};
