package com.ssafy.mvc.dto;

import lombok.Data;

@Data
public class SearchCondition {
	String key = "none";
	String word;
	String order = "none";
	String orderDir = "asc";
}
