package com.ssafy.mvc.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class UserStat {
    private int id; // 고유 식별자
    private String userId; // 유저 아이디
    private int matchId; // 해당 매
    private int shoot; // 슛 스텟
    private int pass; // 패스 스텟
    private int speed; // 속도 스텟
    private int stamina; // 체력 스텟
    private int dribble; // 드리블 스텟
    private LocalDateTime createdAt; // 생성 시간
    private LocalDateTime updatedAt; // 생성 시간
    private LocalDateTime startTime;
    

}
