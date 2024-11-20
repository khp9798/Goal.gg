package com.ssafy.mvc.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Match {
	private int id;                // 고유 ID
	private String name;			//매치 이름 
    private int stadiumId;         // 경기장이 매핑된 ID
    private String stadiumName;		//경기장 이름 
    private LocalDateTime startTime;  // 경기 시작 시간
    private LocalDateTime endTime;    // 경기 종료 시간
    private String status;         // 경기 상태 (pending, approved, rejected, canceled)
    private String image; // 경기장 이미
    private String address; //경기장 주소  
    private String tier; //이 매치의 평균 티어 
	
}
