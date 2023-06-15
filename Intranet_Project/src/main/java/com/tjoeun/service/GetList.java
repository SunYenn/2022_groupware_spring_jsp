package com.tjoeun.service;

import java.util.ArrayList;

import com.tjoeun.vo.ApprovalVO;
import com.tjoeun.vo.AttendVO;
import com.tjoeun.vo.BoardVO;
import com.tjoeun.vo.EmpVO;
import com.tjoeun.vo.MeetRoomVO;
import com.tjoeun.vo.MessageVO;
import com.tjoeun.vo.PerformEvaluVO;
import com.tjoeun.vo.TodoVO;

import lombok.Data;

@Data
public class GetList {
	
	private ArrayList<EmpVO> empList = new ArrayList<EmpVO>();
	private ArrayList<BoardVO> boardList = new ArrayList<BoardVO>();
	private ArrayList<MeetRoomVO> meetRmList = new ArrayList<MeetRoomVO>();
	private ArrayList<MessageVO> msList = new ArrayList<MessageVO>();
	private ArrayList<ApprovalVO> appList = new ArrayList<ApprovalVO>();
	private ArrayList<AttendVO> attList = new ArrayList<AttendVO>();
	private ArrayList<TodoVO> todoList = new ArrayList<TodoVO>();
	private ArrayList<PerformEvaluVO> performList = new ArrayList<PerformEvaluVO>();
	
	private int pageSize = 10; 	
	private int totalCount = 0; 	
	private int totalPage = 0; 		
	private int currentPage = 1;	
	private int startNo = 0;		
	private int endNo = 0; 			
	private int startPage = 0;		
	private int endPage = 0; 	
	
	public GetList() {}
	
	public GetList(int pageSize, int totalCount, int currentPage) {
		this.pageSize = pageSize;
		this.totalCount = totalCount;
		this.currentPage = currentPage;
		calculator();
	}
	
	private void calculator() {
		totalPage = (totalCount - 1) / pageSize + 1;
		currentPage = currentPage > totalPage ? totalPage : currentPage;
		startNo = (currentPage - 1) * pageSize + 1;
		endNo = startNo + pageSize - 1;
		endNo = endNo > totalCount ? totalCount : endNo;
		startPage = (currentPage - 1) / 10 * 10 + 1;
		endPage = startPage + (pageSize - 1);
		endPage = endPage > totalPage ? totalPage : endPage;
	}
}
