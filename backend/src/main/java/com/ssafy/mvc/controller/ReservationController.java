package com.ssafy.mvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.mvc.dto.Reservation;
import com.ssafy.mvc.service.ReservationService;

@RestController
@RequestMapping("/reservations")
@CrossOrigin("*")
public class ReservationController {
	
	@Autowired
	private ReservationService service;
	
	
	//예약 생성
	@PostMapping
	public ResponseEntity<?> create(@RequestParam String userId, @RequestParam int matchId){
		System.out.println("등록 성공 ");
		boolean isCreated = service.insertReservation(userId, matchId);
		
		if(isCreated) {
			return new ResponseEntity<>("create success",HttpStatus.CREATED);
		}
		
		return new ResponseEntity<>("create failed",HttpStatus.BAD_REQUEST);
	}
	
	
	
	//예약 삭제
	@DeleteMapping("/{id}")
	public ResponseEntity<?> delete(@PathVariable int id){
		boolean isDeleted = service.deleteReservation(id);
		
		if(isDeleted) {
			return new ResponseEntity<>("delete success",HttpStatus.OK);
		}
		
		return new ResponseEntity<>("delete failed",HttpStatus.BAD_REQUEST);
	}
	
	
	
	//특정 유저의 모든 예약 조회
	@GetMapping
	public ResponseEntity<?> selectAll(@RequestParam String userid){
		List<Reservation> list = service.selectListByUser(userid);
		System.out.println(userid);
		
		if(!list.isEmpty() && list!=null) {
			return new ResponseEntity<>(list,HttpStatus.OK);
		}
		return new ResponseEntity<>("이 유저의 예약 목록 없음 ",HttpStatus.NO_CONTENT);
	}
	
	
	
	//특정 예약 조회
	@GetMapping("/{id}")
	public ResponseEntity<?> selectOne(@PathVariable int id){
		Reservation reservation = service.selectOne(id);
		
		if(reservation!=null) {
			return new ResponseEntity<>(reservation,HttpStatus.OK);
		}
		
		return new ResponseEntity<>("잘못된 아이디입니다.",HttpStatus.BAD_REQUEST);
	}
}
