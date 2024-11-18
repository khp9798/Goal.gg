package com.ssafy.mvc.dto;

import java.time.LocalDateTime;

import lombok.Data;
@Data
public class Stadium {
	    private int id; // 고유 식별자
	    private String name; // 경기장 이름 
	    private String address; // 경기장 주소
	    private int price; // 대여 비용
	    private int capacity; // 수용 인원
	    private String image; // 경기장 이미지 URL
	    private LocalDateTime createdAt; // 생성 시간 
	    private LocalDateTime updatedAt; // 갱신 시간

}
