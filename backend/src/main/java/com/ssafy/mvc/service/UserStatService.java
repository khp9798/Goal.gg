package com.ssafy.mvc.service;

import java.util.List;

import com.ssafy.mvc.dto.UserStat;

public interface UserStatService {
	
	
	List<UserStat> selectUserAllStat(String userId);//유저 스텟 기록 전체 조회
	
	boolean registUserStat(UserStat userstat); // 유저 스텟 등록
	
	boolean updateUserStat(UserStat userstat); // 유저 스텟 업데이트
	
	UserStat selectUserMatchStat(String userId, int matchId); //해당 경기 해당 유저 스텟 조회


}
