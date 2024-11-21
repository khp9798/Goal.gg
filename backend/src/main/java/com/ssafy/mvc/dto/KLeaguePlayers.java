package com.ssafy.mvc.dto;

import lombok.Data;

@Data
public class KLeaguePlayers {
    private int id; // 고유 식별자
    private String name; // 사용자 이름
    private String position; // 사용자 포지
    private int matchId; // 해당 매
    private int shoot; // 슛 스텟
    private int pass; // 패스 스텟
    private int speed; // 속도 스텟
    private int stamina; // 체력 스텟
    private int dribble; // 드리블 스텟
    private String team;
    private String playerimg;
    private String nation;
    private String nationimg;
    private String seasonimg;
    private String backgoundimg;
    private int playercode;
}