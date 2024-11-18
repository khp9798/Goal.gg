package com.ssafy.mvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.mvc.dao.StadiumDao;
import com.ssafy.mvc.dto.SearchCondition;
import com.ssafy.mvc.dto.Stadium;

@Service
public class StadiumServiceImpl implements StadiumService{

	@Autowired
	private StadiumDao stadiumdao;
	
	@Override
	public List<Stadium> selectAllStadium() {
		return stadiumdao.selectAllStadium();
	}

	@Override
	public Stadium selectStadium(int id) {
		return stadiumdao.selectStadium(id);
	}

	@Override
	public List<Stadium> searchByCondition(SearchCondition condition) {
		return stadiumdao.searchByCondition(condition);
	}

}
