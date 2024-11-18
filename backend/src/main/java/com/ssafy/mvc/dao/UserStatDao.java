package com.ssafy.mvc.dao;

import java.util.List;

import com.ssafy.mvc.dto.UserStat;

public interface UserStatDao {
	
	List<UserStat> selectUserAllStat(String userId);//유저 스텟 기록 전체 조회
	
	// 유저 평균 스텟 기록을 가져오는 건 기록 전체 조회(selectUserAllStat)한 다음에 계산해서 반환해야할
	
	int registUserStat(String userId); // 유저 스텟등
	
	int updateUserStat(String userId); 

}
