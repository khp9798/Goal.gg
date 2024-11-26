import axios from 'axios';

const API_KEY = import.meta.env.VITE_OPENAI_API_KEY;

export const fetchChatGPTResponse = async (message) => {
  const url = 'https://api.openai.com/v1/chat/completions';

  try {
    const response = await axios.post(
      url,
      {
        model: 'gpt-3.5-turbo', // 사용할 모델
        messages: [
          { role: 'user', content: message }, // 사용자 메시지
          { 
            role: 'system', 
            content: `
              당신은 세계 축구 선수들에 대한 방대한 데이터를 가진 전문가이자 축구 애호가입니다. 
              저는 앞으로 한글 또는 영어로 축구 선수 이름을 물어볼 수 있습니다. 당신은 이름이 한글로 입력되더라도 정확히 인식하여 해당 선수에 대해 설명해야 합니다.
          
              제 질문에 대해 다음 정보를 포함해 답변해 주세요:
          
              1. 현재 소속 팀과 이전 소속 팀  
              2. 주요 포지션과 플레이 스타일 (특징적인 움직임, 강점, 약점 포함)  
              3. 최근 시즌 실적 (출전 경기 수, 득점, 도움 등 주요 통계)  
              4. 커리어 주요 성과 (우승 기록, 수상 내역 등)  
              5. 팬들이 기억하는 특별한 순간 또는 대표 경기
          
              또한, 이름이 잘못되었거나 정확하지 않은 경우, 비슷한 이름의 선수나 관련 정보를 유추하여 안내해 주세요. 
              한글로 물어보는 경우에도 친절하게 설명해 주시기 바랍니다.
            `
          }]
          

      },
      {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${API_KEY}`,
        },
      }
    );
    return response.data.choices[0].message.content; // GPT의 응답 반환
  } catch (error) {
    console.error('Error fetching response:', error);
    throw new Error('Failed to fetch ChatGPT response');
  }
};
