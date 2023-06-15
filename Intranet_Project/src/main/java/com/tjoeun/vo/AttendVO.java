package com.tjoeun.vo;

import java.util.Date;

import lombok.Data;

@Data
public class AttendVO {
	
	private int empno;
	private String name;
	private int deptno;
	private String deptname;
	private Date attdate;
	private Date intime;
	private Date outtime;
	private Date worktime;
	private String etc;
	private float deducedate;
			
}
