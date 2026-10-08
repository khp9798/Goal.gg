package com.ssafy.mvc.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClient;
import org.springframework.web.server.ResponseStatusException;

import static org.springframework.http.HttpStatus.BAD_GATEWAY;
import static org.springframework.http.HttpStatus.BAD_REQUEST;
import static org.springframework.http.HttpStatus.SERVICE_UNAVAILABLE;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "http://localhost:5173")
public class ChatController {

    private static final String SYSTEM_PROMPT = """
            당신은 세계 축구 선수들에 대한 정보를 제공하는 축구 전문가입니다.
            사용자가 한국어나 영어로 선수 이름을 물으면 현재·이전 소속 팀, 포지션과 플레이 스타일,
            최근 시즌 실적, 주요 성과와 대표 경기를 한국어로 설명하세요.
            이름이 불명확하면 추측을 사실처럼 말하지 말고 확인이 필요한 부분을 밝혀 주세요.
            """;

    private final RestClient openAiClient;
    private final boolean apiKeyConfigured;
    private final String model;

    public ChatController(
            @Value("${openai.api-key:}") String apiKey,
            @Value("${openai.model:gpt-4.1-mini}") String model) {
        this.apiKeyConfigured = StringUtils.hasText(apiKey);
        this.model = model;
        this.openAiClient = RestClient.builder()
                .baseUrl("https://api.openai.com/v1")
                .defaultHeader(HttpHeaders.AUTHORIZATION, "Bearer " + apiKey)
                .build();
    }

    @PostMapping
    public ChatResponse chat(@RequestBody ChatRequest request) {
        if (!StringUtils.hasText(request.message()) || request.message().length() > 2_000) {
            throw new ResponseStatusException(BAD_REQUEST, "메시지는 1자 이상 2,000자 이하여야 합니다.");
        }

        if (!apiKeyConfigured) {
            throw new ResponseStatusException(SERVICE_UNAVAILABLE, "OPENAI_API_KEY가 설정되지 않았습니다.");
        }

        try {
            OpenAiResponse response = openAiClient.post()
                    .uri("/chat/completions")
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(Map.of(
                            "model", model,
                            "messages", List.of(
                                    Map.of("role", "system", "content", SYSTEM_PROMPT),
                                    Map.of("role", "user", "content", request.message()))))
                    .retrieve()
                    .body(OpenAiResponse.class);

            if (response == null || response.choices() == null || response.choices().isEmpty()
                    || response.choices().get(0).message() == null
                    || !StringUtils.hasText(response.choices().get(0).message().content())) {
                throw new ResponseStatusException(BAD_GATEWAY, "OpenAI 응답이 비어 있습니다.");
            }

            return new ChatResponse(response.choices().get(0).message().content());
        } catch (ResponseStatusException exception) {
            throw exception;
        } catch (Exception exception) {
            throw new ResponseStatusException(BAD_GATEWAY, "OpenAI 요청에 실패했습니다.");
        }
    }

    public record ChatRequest(String message) {}

    public record ChatResponse(String message) {}

    public record OpenAiResponse(List<Choice> choices) {}

    public record Choice(Message message) {}

    public record Message(String content) {}
}
