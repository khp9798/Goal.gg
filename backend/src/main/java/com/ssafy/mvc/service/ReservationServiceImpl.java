package com.ssafy.mvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.mvc.dao.ReservationDao;
import com.ssafy.mvc.dto.Reservation;

@Service
public class ReservationServiceImpl implements ReservationService{

	@Autowired
	private ReservationDao dao;
	
	
	
	@Override
	public boolean insertReservation(Reservation r) {
		return dao.insertReservation(r)>0;
	}

	@Override
	public boolean updateReservation(Reservation r) {
		return dao.updateReservation(r)>0;
	}

	@Override
	public List<Reservation> selectListByUser(String userid) {
		return dao.selectListByUser(userid);
	}

	@Override
	public Reservation selectOne(int id) {
		return dao.selectOne(id);
	}

	@Override
	public boolean deleteReservation(int id) {
		return dao.deleteReservation(id)>0;
	}

}
