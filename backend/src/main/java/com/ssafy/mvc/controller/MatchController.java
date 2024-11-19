package com.ssafy.mvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.mvc.dto.Match;
import com.ssafy.mvc.dto.SearchCondition;
import com.ssafy.mvc.service.MatchService;

@RestController
@RequestMapping("/matches")
public class MatchController {
	
	@Autowired
	private MatchService mService;
	
	
	//새로운 매치 등록 
	@PostMapping
	public ResponseEntity<?> createMatch(@RequestBody Match match){
		boolean isCreated = mService.insertMatch(match);
		
		if(isCreated) {
			return new ResponseEntity<String>("create success",HttpStatus.CREATED);
		}
		return new ResponseEntity<String>("create failed",HttpStatus.BAD_REQUEST);
	}
	
	
	
	//경기 정보 수정 
	@PutMapping
	public ResponseEntity<?> updateMatch(@RequestBody Match match){
		if (match==null) {
			return new ResponseEntity<String>("match 객체가 null값 입니다.",HttpStatus.BAD_REQUEST);
		}
		boolean isUpdated = mService.updateMatch(match);
		
		if(isUpdated) {
			return new ResponseEntity<String>("update success",HttpStatus.OK);
		}
		return new ResponseEntity<String>("update failed",HttpStatus.BAD_REQUEST);
	}
	
	
	
	//특정 매치 삭제하기
	@DeleteMapping("/{id}")
	public ResponseEntity<?> deleteMatch(@PathVariable int id){
		boolean isDeleted = mService.deleteMatch(id);
		
		if(isDeleted) {
			return new ResponseEntity<String>("delete success",HttpStatus.OK);
		}
		return new ResponseEntity<String>("delete failed",HttpStatus.BAD_REQUEST);
	}
	
	
	
	
	//매치 검색
	@GetMapping
	public ResponseEntity<?> search(@ModelAttribute SearchCondition search){
		List<Match> list = mService.searchByCondition(search);
		
		if(!list.isEmpty() && list!=null) {
			return new ResponseEntity<>(list,HttpStatus.OK);
		}
		System.out.println(search);
		return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
	}
	
	
	//특정 매치 조회
	@GetMapping("/{id}")
	public ResponseEntity<?> selectOne(@PathVariable int id){
		Match match = mService.selectOne(id);
		
		if(match!=null) {
			return new ResponseEntity<>(match,HttpStatus.OK);
		}
		
		return new ResponseEntity<>("그런 아이디를 가진 match는 없습니다.",HttpStatus.NOT_FOUND);
	}
	
}
