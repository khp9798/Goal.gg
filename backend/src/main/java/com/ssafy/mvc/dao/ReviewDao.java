package com.ssafy.mvc.dao;

import java.util.List;

import com.ssafy.mvc.dto.Review;

public interface ReviewDao {

	//리뷰 등록 
	int insertReview(Review review);
	
	//특정 경기의 리뷰 목록 조회  
	List<Review> selectReviewByMatch (int mid);
	
	//특정 리뷰 조회 
	Review selectOne(int id);
	
	//리뷰 삭제  
	int deleteReview(int id);
	
	//리뷰 업데이트 
	int updateReview(Review review);
	
}
