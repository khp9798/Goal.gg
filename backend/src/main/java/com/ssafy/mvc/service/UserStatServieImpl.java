package com.ssafy.mvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.mvc.dao.UserStatDao;
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
	public boolean registUserStat(String userId) {
		int result = userstatdao.registUserStat(userId);
		return result>0;
	}

	@Override
	public boolean updateUserStat(String userId) {
		int result = userstatdao.updateUserStat(userId);
		return result>0;
	}

}
