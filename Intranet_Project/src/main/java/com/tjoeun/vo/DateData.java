package com.tjoeun.vo;

import java.util.ArrayList;

import lombok.Data;

@Data
public class DateData {
	
	private int year; 
	private int month;
	private int date;
	private String status; // today, normal_date 구별
	private String event; // 공휴일
	private int yearLunar; // 음력 년
	private int monthLunar; // 음력 월
	private int dayLunar; // 음력 일
	private ArrayList<TodoVO> todoList = new ArrayList<TodoVO>(); // todo 리스트

	public DateData() { }

	public DateData(int year, int month, int date) {
		this.year = year;
		this.month = month;
		this.date = date;
	}
	
	public DateData(int year, int month, int date, String status, String event, int yearLunar, int monthLunar, int dayLunar) {
		this.year = year;
		this.month = month;
		this.date = date;
		this.status = status;
		this.event = event;
		this.yearLunar = yearLunar;
		this.monthLunar = monthLunar;
		this.dayLunar = dayLunar;
	}

}
