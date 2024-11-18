package com.ssafy.mvc.dto;

import lombok.Data;

@Data
public class MatchSearch {
	String key = "none";
	String word;
	String order = "none";
	String orderDir = "asc";
}
