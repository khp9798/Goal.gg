package com.ssafy.mvc.service;

import java.util.List;

import com.ssafy.mvc.dto.Reservation;

public interface ReservationService {
	// 에약 생성
	boolean insertReservation(Reservation r);

	// 예약 상태 업데이트
	boolean updateReservation(Reservation r);

	// 예약 삭제
	boolean deleteReservation(int id);

	// 예약 조회
	List<Reservation> selectListByUser(String userid);

	Reservation selectOne(int id);
}
