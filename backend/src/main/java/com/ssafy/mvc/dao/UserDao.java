package com.ssafy.mvc.dao;

import com.ssafy.mvc.dto.User;

public interface UserDao {
	
	
	int registUser(User user); // 회원가입
	
	User selectUser(String id); // 유저 조회(로그인, 유저조회, 삭제)
	
	
	
	

}
