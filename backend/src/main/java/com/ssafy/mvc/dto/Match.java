package com.ssafy.mvc.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Match {
	private int id;                // 고유 ID
    private int stadiumId;         // 경기장이 매핑된 ID
    private LocalDateTime startTime;  // 경기 시작 시간
    private LocalDateTime endTime;    // 경기 종료 시간
    private String status;         // 경기 상태 (pending, approved, rejected, canceled)
	
}
