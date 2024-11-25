package com.ssafy.mvc.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.mvc.dto.Match;
import com.ssafy.mvc.dto.SearchCondition;
import com.ssafy.mvc.service.MatchService;

@RestController
@RequestMapping("/matches")
@CrossOrigin("*")
public class MatchController {

	@Autowired
	private MatchService mService;

	// 새로운 매치 등록
	@PostMapping
	public ResponseEntity<?> createMatch(@RequestBody Match match) {
		System.out.println(match);
		boolean isCreated = mService.insertMatch(match);

		if (isCreated) {
			return new ResponseEntity<String>("create success", HttpStatus.CREATED);
		}
		return new ResponseEntity<String>("create failed", HttpStatus.BAD_REQUEST);
	}

	// 경기 정보 수정
	@PutMapping
	public ResponseEntity<?> updateMatch(@RequestBody Match match) {
		System.out.println(match);
		if (match == null) {
			return new ResponseEntity<String>("match 객체가 null값 입니다.", HttpStatus.BAD_REQUEST);
		}
		boolean isUpdated = mService.updateMatch(match);

		if (isUpdated) {
			return new ResponseEntity<String>("update success", HttpStatus.OK);
		}
		return new ResponseEntity<String>("update failed", HttpStatus.BAD_REQUEST);
	}

	// 특정 매치 삭제하기
	@DeleteMapping("/{id}")
	public ResponseEntity<?> deleteMatch(@PathVariable int id) {
		boolean isDeleted = mService.deleteMatch(id);

		if (isDeleted) {
			return new ResponseEntity<String>("delete success", HttpStatus.OK);
		}
		return new ResponseEntity<String>("delete failed", HttpStatus.BAD_REQUEST);
	}

	// 지역 매치 검색 
	@GetMapping("/search")
	public ResponseEntity<?> search(@RequestParam String region) {
		List<Match> list = mService.searchByCondition(region);

		if (!list.isEmpty() && list != null) {
			return new ResponseEntity<>(list, HttpStatus.OK);
		}
//		System.out.println(region);
		return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
	}

	// 모든 매치 정보 가져오기
	@GetMapping
	public ResponseEntity<?> selectAll() {

		List<Match> list = mService.selectAll();

		if (!list.isEmpty() && list != null) {
			return new ResponseEntity<>(list, HttpStatus.OK);
		}

		return ResponseEntity.status(HttpStatus.NO_CONTENT).build();

	}
	
	
	//모든 예약 가능한 매치 정보 가져오기
	@GetMapping("list")
	public ResponseEntity<?> selectList(){
		
		List<Match> list = mService.selectcanList();
		
		if(!list.isEmpty() && list!=null) {
			return new ResponseEntity<>(list,HttpStatus.OK);
		}
		return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
		
	}

	// 특정 매치 조회
	@GetMapping("/{id}")
	public ResponseEntity<?> selectOne(@PathVariable int id) {
//		System.out.println(id);
		Match match = mService.selectOne(id);
//		System.out.println(match);

		if (match != null) {
			return new ResponseEntity<>(match, HttpStatus.OK);
		}
		
		return new ResponseEntity<>("그런 아이디를 가진 match는 없습니다.", HttpStatus.NOT_FOUND);
	}
	
	
	// 특정 매치의 평균 티어 반환
	@GetMapping("/tier/{matchId}")
	public ResponseEntity<?> getMatchAvgTier(@PathVariable int matchId){
		String avgTier = mService.matchAvgTier(matchId);
//		System.out.println(avgTier);
		if(avgTier!=null) {
			return new ResponseEntity<>(avgTier,HttpStatus.OK);
		}
		return new ResponseEntity<>("이 매치의 예약이 없습니다.",HttpStatus.NO_CONTENT);
	}
	
	// 특정 경기장 매치 조회
	@GetMapping("/match/{id}")
	public ResponseEntity<?> selectStadiumMatch(@PathVariable int id) {
		List<Match> list = mService.selectStadiumMatch(id);
//		System.out.println(id);
//		System.out.println(list);
		if (list != null) {
			return new ResponseEntity<>(list, HttpStatus.OK);
		}

		return new ResponseEntity<>("해당 경기장에 매치가 없습니다.", HttpStatus.NOT_FOUND);
	}
	
	// 특정 경기장 특정 날짜 매치 조회
	@GetMapping("/match/{id}/{date1}/{date2}")
	public ResponseEntity<?> selectStadiumDayMatch(@PathVariable int id, @PathVariable String date1,@PathVariable String date2) {
		List<Match> list = mService.selectStadiumDayMatch(id, date1, date2);
//		System.out.println(id);
//		System.out.println(date);
//		System.out.println(list);
		if (list != null) {
			return new ResponseEntity<>(list, HttpStatus.OK);
		}

		return new ResponseEntity<>("해당 경기장에 매치가 없습니다.", HttpStatus.NOT_FOUND);
	}
	
	
	
	@GetMapping("/recommand")
	public ResponseEntity<?> RecommandMatchList(@RequestParam String district,@RequestParam String province){
//		System.out.println("시 : "+province);
//		System.out.println("구 : "+district);
		List<Match> recommandList = mService.RecommandMatchList(district, province);
		
		if(!recommandList.isEmpty() && recommandList!=null) {
			return new ResponseEntity<>(recommandList, HttpStatus.OK);
		}
		
		return new ResponseEntity<>("주변에 매치가 없습니다.",HttpStatus.NO_CONTENT);
	}
	
	//해당 매니저 담당 매치 조회
	@GetMapping("/manager")
	public ResponseEntity<?> getMatchManagerList(@RequestParam int id) {
		List<Match> list = mService.getMatchManagerList(id);

		if (!list.isEmpty() && list != null) {
			return new ResponseEntity<>(list, HttpStatus.OK);
		}
//		System.out.println(id);
		return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
	}

}
