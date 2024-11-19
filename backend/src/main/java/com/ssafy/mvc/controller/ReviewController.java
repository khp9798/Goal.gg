package com.ssafy.mvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.mvc.dto.Review;
import com.ssafy.mvc.service.ReviewService;

@RestController
@RequestMapping("/reviews")
public class ReviewController {
	
	
	@Autowired
	private ReviewService rService;
	
	
	//리뷰 등록
	@PostMapping
	public ResponseEntity<?> createReview(@RequestBody Review review){
		boolean isCreated = rService.insertReview(review);
		
		if(isCreated) {
			return new ResponseEntity<>("create success",HttpStatus.CREATED);
		}
		
		return new ResponseEntity<>("create failed",HttpStatus.BAD_REQUEST);
	}
	
	
	
	//리뷰 삭제
	@DeleteMapping
	public ResponseEntity<?> deleteReview(@RequestParam int id, @RequestParam String userid){
		if(id==0 || userid==null) {
			return new ResponseEntity<>("id 또는 userid가 null입니다.",HttpStatus.BAD_REQUEST);
		}
		
		boolean isDeleted = rService.deleteReview(id, userid);
		
		if(isDeleted) {
			return new ResponseEntity<>("delete success",HttpStatus.OK);
		}
		
		return new ResponseEntity<>("delete failed",HttpStatus.BAD_REQUEST);
	}
	
	
	
	//특정 매치의 리뷰 조회
	@GetMapping("/match")
	public ResponseEntity<?> selectReview(@RequestParam int matchId){
		List<Review> list = rService.selectReviewByMatch(matchId);
		
		if(!list.isEmpty() && list!=null) {
			return new ResponseEntity<>(list,HttpStatus.OK);
		}
		return new ResponseEntity<>("이 경기엔 리뷰가 아직 없습니다.",HttpStatus.NO_CONTENT);
	}
	
	
	
	
	//특정 리뷰 조회
	@GetMapping("/{id}")
	public ResponseEntity<?> selectOne(@PathVariable int id){
		Review review = rService.selectOne(id);
		
		if(review!=null) {
			return new ResponseEntity<>(review,HttpStatus.OK);
		}
		
		return new ResponseEntity<>("잘못된 리뷰 id입니다.",HttpStatus.BAD_REQUEST);
	}
	
}
