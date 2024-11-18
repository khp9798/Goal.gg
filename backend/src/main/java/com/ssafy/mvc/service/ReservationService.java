package com.ssafy.mvc.service;

import java.util.List;

import com.ssafy.mvc.dto.Reservation;

public interface ReservationService {
	// 에약 생성
	boolean insertReservation(Reservation r);

	// 예약 삭제
	boolean deleteReservation(int id);

	// 예약 조회
	List<Reservation> selectListByUser(String userid);

	// 해당되는 매치의 예약들 조회
	List<Reservation> ListByMatchId(int matchId);

	Reservation selectOne(int id);
}
