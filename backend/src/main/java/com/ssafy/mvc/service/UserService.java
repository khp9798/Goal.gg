package com.ssafy.mvc.service;

import com.ssafy.mvc.dto.User;

public interface UserService {
	boolean registUser(User user); // 회원가입
	
	User selectUser(String id); // 유저 조회(로그인, 유저조회, 삭제)

}
