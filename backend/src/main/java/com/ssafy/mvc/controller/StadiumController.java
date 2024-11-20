package com.ssafy.mvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.mvc.dto.SearchCondition;
import com.ssafy.mvc.dto.Stadium;
import com.ssafy.mvc.service.StadiumService;

@RestController
@RequestMapping("/stadium")
@CrossOrigin("*")
public class StadiumController {
	
	@Autowired
	private StadiumService stadiumservice ;
	
	
	//스타디움 정보 조회
	@GetMapping
	public ResponseEntity<?> selectAllStadium(){
		List<Stadium> list = stadiumservice.selectAllStadium();
		System.out.println(list);
		if(!list.isEmpty()) {
			return new ResponseEntity<>(list,HttpStatus.OK);
		}
		return new ResponseEntity<>("조회에 실패했습니다",HttpStatus.NOT_FOUND);
	}
	
	@GetMapping("/{id}")
	public ResponseEntity<?> selectStadium(@PathVariable int id){
		Stadium stadium = stadiumservice.selectStadium(id);
		if(stadium!=null) {
			return new ResponseEntity<>(stadium,HttpStatus.OK);
		}
		return new ResponseEntity<>("조회에 실패했습니다",HttpStatus.NOT_FOUND);
	}
	
	@GetMapping("/search")
	public ResponseEntity<?> searchByCondition(@ModelAttribute SearchCondition condition){
		System.out.println(condition);
		List<Stadium> list = stadiumservice.searchByCondition(condition);
		if(!list.isEmpty()) {
			return new ResponseEntity<>(list,HttpStatus.OK);
		}
		return new ResponseEntity<>("조회에 실패했습니다",HttpStatus.NOT_FOUND);
	}

}
