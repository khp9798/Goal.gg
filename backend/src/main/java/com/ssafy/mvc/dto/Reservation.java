package com.ssafy.mvc.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Reservation {
	private int id;                // 예약 ID
    private String userId;            // 예약한 사용자 ID
    private int matchId;           // 예약한 경기 ID
    private LocalDateTime reservationDate; // 예약 날짜 및 시간
    private LocalDateTime createdAt;       // 생성 시간
    private LocalDateTime updatedAt;       // 갱신 시간
    private String name;	//예약한 매치 이름
    private LocalDateTime startTime;  // 경기 시작 시간
    private LocalDateTime endTime;    // 경기 종료 시간
	
}
