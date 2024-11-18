package com.ssafy.mvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.mvc.dao.ReviewDao;
import com.ssafy.mvc.dto.Review;

@Service
public class ReviewServiceImpl implements ReviewService{

	@Autowired
	private ReviewDao dao;
	
	@Override
	public boolean insertReview(Review review) {
		return dao.insertReview(review)>0;
	}

	@Override
	public List<Review> selectReviewByMatch(int mid) {
		return dao.selectReviewByMatch(mid);
	}

	@Override
	public Review selectOne(int id) {
		return dao.selectOne(id);
	}

	@Override
	public boolean deleteReview(int id) {
		return dao.deleteReview(id)>0;
	}

	@Override
	public boolean updateReview(Review review) {
		return dao.updateReview(review)>0;
	}

}
