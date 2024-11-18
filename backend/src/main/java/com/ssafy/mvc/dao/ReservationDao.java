package com.ssafy.mvc.dao;

import java.util.List;

import com.ssafy.mvc.dto.Reservation;

public interface ReservationDao {

	//에약 생성
	int insertReservation(Reservation r);
	
	//예약 상태 업데이트
	int updateReservation(Reservation r);
	
	//예약 삭제
	int deleteReservation(int id);
	
	
	//예약 조회
	List<Reservation> selectListByUser (String userid);
	
	
	Reservation selectOne(int id);
	
}
