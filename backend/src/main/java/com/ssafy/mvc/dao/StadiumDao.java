package com.ssafy.mvc.dao;

import java.util.List;

import com.ssafy.mvc.dto.SearchCondition;
import com.ssafy.mvc.dto.Stadium;


public interface StadiumDao {
	
	//모든 경기장 조회
	List<Stadium> selectAllStadium();
	
	//특정 경기장 조회
	Stadium selectStadium(int id);
	
	List<Stadium> searchByCondition(SearchCondition condition);


}
