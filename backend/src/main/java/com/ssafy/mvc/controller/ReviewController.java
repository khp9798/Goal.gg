package com.ssafy.mvc.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
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
	
	
	@PostMapping
	public ResponseEntity<?> createReview(@RequestBody Review review){
		boolean isCreated = rService.insertReview(review);
		
		if(isCreated) {
			return new ResponseEntity<>("create success",HttpStatus.CREATED);
		}
		
		return new ResponseEntity<>("create failed",HttpStatus.BAD_REQUEST);
	}
	
	
	@DeleteMapping
	public ResponseEntity<?> deleteReview(@RequestParam int id, @RequestParam int userid){
		if(id==0 || userid==0) {
			return new ResponseEntity<>("id 또는 userid가 null입니다.",HttpStatus.BAD_REQUEST);
		}
		
		boolean isDeleted = rService.deleteReview(id, userid);
		
		if(isDeleted) {
			return new ResponseEntity<>("delete success",HttpStatus.OK);
		}
		
		return new ResponseEntity<>("delete failed",HttpStatus.BAD_REQUEST);
	}
	
}
