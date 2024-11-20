package com.ssafy.mvc.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.mvc.dao.UserStatDao;
import com.ssafy.mvc.dto.KLeaguePlayers;
import com.ssafy.mvc.dto.UserStat;

@Service
public class UserStatServieImpl implements UserStatService {
	
	@Autowired
	private UserStatDao userstatdao;
	
	@Override
	public List<UserStat> selectUserAllStat(String userId) {
		return userstatdao.selectUserAllStat(userId);
	}

	@Override
	public boolean registUserStat(UserStat userstat) {
		int result = userstatdao.registUserStat(userstat);
		return result>0;
	}

	@Override
	public boolean updateUserStat(UserStat userstat) {
		int result = userstatdao.updateUserStat(userstat);
		return result>0;
	}

	@Override
	public UserStat selectUserMatchStat(String userId, int matchId) {
		return userstatdao.selectUserMatchStat(userId, matchId);
	}

	@Override
	public List<KLeaguePlayers> selectMyLeague(Map<String, Integer> stat) {
		return userstatdao.selectMyLeage(stat);
	}

}
