package com.ssafy.mvc.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.mvc.dto.User;
import com.ssafy.mvc.service.UserService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/users")
public class UserController {
	
	@Autowired
	private UserService uService;
	
	//회원가입
	@PostMapping("/regist")
	public ResponseEntity<?> registUser(@RequestBody User user){
		if(user.getUserid() == null || user.getPassword() == null ||user.getName() == null ||
				user.getEmail()==null || user.getPhoneNumber()==null || user.getRole() ==null||
				user.getTier()==null||user.getCreatedAt()==null) {
			return new ResponseEntity<>("유저 정보 중 하나가 빠져있는 것 같습니다", HttpStatus.BAD_REQUEST);
		}
		boolean success = uService.registUser(user);
		if(success) {
			return new ResponseEntity<>("유저 생성에 성공했습니다", HttpStatus.CREATED);
		}
		return new ResponseEntity<>("아이디가 중복된 것 같습니다",HttpStatus.NOT_ACCEPTABLE);
	}
	
	//로그인 
	@PostMapping("/login")
	public ResponseEntity<?> loginUser(@RequestBody User loginUser, HttpSession session){
		User user = uService.selectUser(loginUser.getUserid());
		if(user != null && user.getUserid().equals(loginUser.getUserid())
				&& user.getPassword().equals(loginUser.getPassword())) {
			session.setAttribute("loginUserName", user.getName());
			session.setAttribute("loginUserId", user.getUserid());
			session.setAttribute("role", user.getRole());
			/*
			 * 인증 관리 추가해야
			 */
			return new ResponseEntity<>(user.getName(),HttpStatus.ACCEPTED);
		}
		return new ResponseEntity<>("로그인 실패",HttpStatus.BAD_REQUEST);
		
	}
	
	//유저 정보 조회
	@GetMapping
	public ResponseEntity<?> selectUser(@RequestParam("id") String id, HttpSession session){
		User user = uService.selectUser(id);
		String loginUserId = (String) session.getAttribute("loginUserId");
		String role = (String) session.getAttribute("role");
		/*
		 * 관리자나 매니저는 user 정보 볼 수 있긴 한데 일부 정보만 주도록 수정 필요해보임
		 */
		
		if(role.equals("admin")||role.equals("manager")) {
			return new ResponseEntity<>(user,HttpStatus.OK);
		} else if(user != null && user.getUserid().equals(loginUserId)) {
			return new ResponseEntity<>(user,HttpStatus.OK);
		} else if(user==null) {
			return new ResponseEntity<>("유저 정보가 없습니다", HttpStatus.BAD_REQUEST);
		}
		return new ResponseEntity<>("권한이 없는 것 같습니다",HttpStatus.NOT_FOUND);
		
	}

}
