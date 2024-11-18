package com.ssafy.mvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.mvc.dao.MatchDao;
import com.ssafy.mvc.dto.Match;
import com.ssafy.mvc.dto.MatchSearch;

@Service
public class MatchServiceImpl implements MatchService{

	@Autowired
	private MatchDao dao;

	@Override
	public boolean insertMatch(Match match) {
		return dao.insertMatch(match) > 0;
	}

	@Override
	public boolean updateMatch(Match match) {
		return dao.updateMatch(match)>0;
	}

	@Override
	public boolean deleteMatch(int id) {
		return dao.deleteMatch(id)>0;
	}

	@Override
	public List<Match> searchByCondition(MatchSearch matchSearch) {
		return dao.searchByCondition(matchSearch);
	}

	@Override
	public Match selectOne(int id) {
		return dao.selectOne(id);
	}
	
	

}
