package com.ssafy.mvc.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Review {
	private int id;                // 고유 ID
    private int userId;            // 리뷰를 작성한 사용자 ID
    private int matchId;           // 리뷰 대상 경기 ID
    private int rating;            // 별점 (1~5)
    private String comment;        // 리뷰 내용
    private LocalDateTime createdAt; // 생성 시간
    private LocalDateTime updatedAt; // 갱신 시간
}
