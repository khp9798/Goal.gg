package com.ssafy.mvc.dao;

import java.util.List;

import com.ssafy.mvc.dto.Reservation;

public interface ReservationDao {

	//에약 생성
	int insertReservation(Reservation r);
	
	
	//예약 삭제
	int deleteReservation(int id);
	
	
	//예약 조회
	List<Reservation> selectListByUser (int userid);
	
	
	Reservation selectOne(int id);
	
}
