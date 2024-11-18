package com.ssafy.mvc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.mvc.dao.UserDao;
import com.ssafy.mvc.dto.User;

@Service
public class UserServiceImpl implements UserService {
	
	@Autowired
	private UserDao uDao;

	@Override
	public boolean registUser(User user) {
		int result = uDao.registUser(user);
		return result>0;
	}

	@Override
	public User selectUser(String id) {
		System.out.println(id);
		System.out.println('c');
		System.out.println('b');
		
		System.out.println("aa");
		return uDao.selectUser(id);
	}
	
	

}
