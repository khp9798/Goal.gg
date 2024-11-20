package com.ssafy.mvc.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.mvc.dto.KLeaguePlayers;
import com.ssafy.mvc.dto.UserStat;
import com.ssafy.mvc.service.UserStatService;

@RestController
@RequestMapping("/userstat")
@CrossOrigin("*")
public class UserStatController {

	@Autowired
	private UserStatService userstatservice;

	// 스텟 등록
	@PostMapping
	public ResponseEntity<?> registUserStat(@RequestBody UserStat userstat) {
		boolean success = userstatservice.registUserStat(userstat);
		if (success) {
			return new ResponseEntity<>("유저 스텟 등록에 성공했습니다", HttpStatus.CREATED);
		}
		return new ResponseEntity<>("유저 스텟 등록에 실패했습니다", HttpStatus.BAD_REQUEST);
	}

	// 스텟 기록 전체 조회
	@GetMapping
	public ResponseEntity<?> selectUserAllStat(@RequestParam String userId) {
		List<UserStat> list = userstatservice.selectUserAllStat(userId);
		if (list != null) {
			return new ResponseEntity<>(list, HttpStatus.OK);
		}
		return new ResponseEntity<>("스텟 전체 조회에 실패했습니다", HttpStatus.NOT_FOUND);
	}

	// 해당 경기 해당 유저 스텟 조회
	@GetMapping("/match")
	public ResponseEntity<?> selectUserMatchStat(@RequestParam String userId, @RequestParam int matchId) {
		UserStat stat = userstatservice.selectUserMatchStat(userId, matchId);
		if (stat != null) {
			return new ResponseEntity<>(stat, HttpStatus.OK);
		}
		return new ResponseEntity<>("해당 경기 스텟 조회에 실패했습니다", HttpStatus.NOT_FOUND);
	}

	// 스텟 평균 조회
	@GetMapping("/avg")
	public ResponseEntity<?> selectUserAvgStat(@RequestParam String userId) {
//		System.out.println(userId);
		List<UserStat> list = userstatservice.selectUserAllStat(userId);
//		System.out.println(list);
		int size = list.size();
		int shoot = 0;
		int pass = 0;
		int speed = 0;
		int stamina = 0;
		int dribble = 0;
		if (list.size() != 0) {
			for (int i = 0; i < list.size(); i++) {
				shoot += list.get(i).getShoot();
				pass += list.get(i).getPass();
				speed += list.get(i).getSpeed();
				stamina += list.get(i).getStamina();
				dribble += list.get(i).getDribble();
			}
			Map<String, Integer> stat = new HashMap<>();
			stat.put("shoot", shoot /= size);
			stat.put("pass", pass /= size);
			stat.put("speed", speed /= size);
			stat.put("stamina", stamina /= size);
			stat.put("dribble", dribble /= size);
//			System.out.println(stat);
			return new ResponseEntity<>(stat, HttpStatus.OK);
		}
		return new ResponseEntity<>("스텟 전체 조회에 실패했습니다", HttpStatus.NOT_FOUND);
	}
	// GET /userstat/:id: 해당 경기에 참가하는 유저 평균 스텟 조회.(매니저만)
	// match, reservation 제작 후 제작 예정

	@PutMapping
	public ResponseEntity<?> updateUserStat(UserStat updateduserstat) {
//		UserStat stat = userstatservice.selectUserMatchStat(updateduserstat.getUserId(), updateduserstat.getMatchId());
		boolean success = userstatservice.updateUserStat(updateduserstat);
		if (!success) {
			return new ResponseEntity<>("해당 스텟 조회에 실패했습니다", HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<>("스텟 수정에 성공했습니다.", HttpStatus.OK);
	}

	// 유사한 선수 탐색
	@PostMapping("/kleague")
	public ResponseEntity<?> selectMyLeague(@RequestParam String userId) {
		List<UserStat> list = userstatservice.selectUserAllStat(userId);
		int size = list.size();
		int shoot = 0;
		int pass = 0;
		int speed = 0;
		int stamina = 0;
		int dribble = 0;
		if (list.size() != 0) {
			for (int i = 0; i < list.size(); i++) {
				shoot += list.get(i).getShoot();
				pass += list.get(i).getPass();
				speed += list.get(i).getSpeed();
				stamina += list.get(i).getStamina();
				dribble += list.get(i).getDribble();
			}
			Map<String, Integer> stat = new HashMap<>();
			stat.put("shoot", shoot /= size);
			stat.put("pass", pass /= size);
			stat.put("speed", speed /= size);
			stat.put("stamina", stamina /= size);
			stat.put("dribble", dribble /= size);
			List<KLeaguePlayers> players = userstatservice.selectMyLeague(stat);
			System.out.println(players);
			Random random = new Random();
			KLeaguePlayers player = players.get(random.nextInt(players.size()));
			return new ResponseEntity<>(player,HttpStatus.OK);
			
		}
		return new ResponseEntity<>("실패했어요 ㅠㅠ",HttpStatus.NOT_FOUND);
	}

}
