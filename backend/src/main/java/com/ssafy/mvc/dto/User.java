package com.ssafy.mvc.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class User {
    private int id; // 고유 식별자
    private String userid; // 로그인용 아이디
    private String password; // 암호화된 비밀번호
    private String email; // 이메일
    private String phoneNumber; // 전화번호
    private String name; // 사용자 이름
    private String role; // 사용자 역할(권한지정)
    private String position; // 사용자 포지
    private String tier; // 사용자 티어
    private String region; // 사용자 지역 -> ex)수도권
    private String province; // 사용자 지역 -> ex)서울
    private String district; // 사용자 지역 -> ex)관악구
    private LocalDateTime createdAt; // 생성 시간
}
