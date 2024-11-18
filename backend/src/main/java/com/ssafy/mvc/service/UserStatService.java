package com.ssafy.mvc.service;

import java.util.List;

import com.ssafy.mvc.dto.UserStat;

public interface UserStatService {
	
	
	List<UserStat> selectUserAllStat(String userId);//유저 스텟 기록 전체 조회
	
	boolean registUserStat(String userId); // 유저 스텟 등록
	
	boolean updateUserStat(String userId); // 유저 스텟 업데이트

}
