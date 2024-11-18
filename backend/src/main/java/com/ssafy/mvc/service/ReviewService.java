package com.ssafy.mvc.service;

import java.util.List;

import com.ssafy.mvc.dto.Review;

public interface ReviewService {
	// 리뷰 등록
	boolean insertReview(Review review);

	// 특정 경기의 리뷰 목록 조회
	List<Review> selectReviewByMatch(int mid);

	// 특정 리뷰 조회
	Review selectOne(int id);

	// 리뷰 삭제
	boolean deleteReview(int id);

	// 리뷰 업데이트
	boolean updateReview(Review review);
}
