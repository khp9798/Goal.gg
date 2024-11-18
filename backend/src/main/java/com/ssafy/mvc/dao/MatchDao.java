package com.ssafy.mvc.dao;

import java.util.List;

import com.ssafy.mvc.dto.Match;
import com.ssafy.mvc.dto.MatchSearch;


public interface MatchDao {
	
	//새로운 경기 등록
	int insertMatch(Match match);
	
	
	//경기 일정 및 세부 정보 수정
	int updateMatch(Match match);
	
	//경기 취소
	int deleteMatch(int id);
	
	
	//경기 목록 조회
	List<Match> searchByCondition (MatchSearch matchSearch);
	
	//특정 경기 세부 정보 조회
	Match selectOne (int id);
	
}
