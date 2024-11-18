package com.ssafy.mvc.service;

import java.util.List;

import com.ssafy.mvc.dto.Match;
import com.ssafy.mvc.dto.MatchSearch;

public interface MatchService {

	// 새로운 경기 등록
	boolean insertMatch(Match match);

	// 경기 일정 및 세부 정보 수정
	boolean updateMatch(Match match);

	// 경기 취소
	boolean deleteMatch(int id);

	// 경기 목록 조회
	List<Match> searchByCondition(MatchSearch matchSearch);

	// 특정 경기 세부 정보 조회
	Match selectOne(int id);
}
