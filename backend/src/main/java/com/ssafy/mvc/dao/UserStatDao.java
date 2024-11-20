package com.ssafy.mvc.dao;

import java.util.List;
import java.util.Map;

import com.ssafy.mvc.dto.KLeaguePlayers;
import com.ssafy.mvc.dto.UserStat;

public interface UserStatDao {
	
	List<UserStat> selectUserAllStat(String userId);//유저 스텟 기록 전체 조회
	
	// 유저 평균 스텟 기록을 가져오는 건 기록 전체 조회(selectUserAllStat)한 다음에 계산해서 반환해야할
	
	int registUserStat(UserStat userstat); // 유저 스텟 등
	
	int updateUserStat(UserStat userstat); // 유저 스텟 업데이트
	
	UserStat selectUserMatchStat(String userId, int matchId); //해당 경기 해당 유저 스텟 조회

	List<KLeaguePlayers> selectMyLeage(Map<String, Integer> stat);

}
