package com.ssafy.mvc.dto;

import lombok.Data;

@Data
public class MatchSearch {
	String key;
	String word;
	String order;
	String orderDir;
}
