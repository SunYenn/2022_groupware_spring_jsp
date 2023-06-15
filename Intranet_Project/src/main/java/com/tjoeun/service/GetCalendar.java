package com.tjoeun.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.tjoeun.dao.MyBatisDAO;
import com.tjoeun.vo.DateData;
import com.tjoeun.vo.TodoVO;

public class GetCalendar {
	

	// 한달 필드를 생성하는 메소드
	public static List<DateData> month_info(DateData date, SqlSession sqlSession, TodoVO todo) {
		
		MyBatisDAO mapper = sqlSession.getMapper(MyBatisDAO.class);
		
		List<DateData> dateList = new ArrayList<DateData>();
		DateData calendarData;

		Calendar cal = Calendar.getInstance();
		cal.set(date.getYear(), date.getMonth() -1 , 1);

		int endDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH); // 달의 마지막 날
		int start = cal.get(Calendar.DAY_OF_WEEK); // 시작 요일

		long time = System.currentTimeMillis();
		SimpleDateFormat ysdf = new SimpleDateFormat("yyyy");
		SimpleDateFormat msdf = new SimpleDateFormat("MM");

		int curr_year = Integer.parseInt(ysdf.format(time));
		int curr_month = Integer.parseInt(msdf.format(time));

		int today = -1;
		if (curr_year == date.getYear() && curr_month == date.getMonth()) {
			SimpleDateFormat dsdf = new SimpleDateFormat("dd");
			today = Integer.parseInt(dsdf.format(time));
		}
		
		// 달력 앞 빈곳 빈 데이터 삽입
		for (int i = 1; i < start; i++) {
			calendarData = new DateData();
			dateList.add(calendarData);
		}
		
		// 날짜 삽입 & 음력 크롤링
		String targetSite = "";
		targetSite =  String.format("https://astro.kasi.re.kr/life/pageView/5?search_year=%04d&search_month=%02d&search_check=G", date.getYear(), date.getMonth());
		
		try {
			Document document = Jsoup.connect(targetSite).get();
			
			Elements elements = document.select("tbody > tr");
			
			for (Element element : elements) {

				Elements ele = element.select("td");

				String sola = ele.get(0).text();
				String lunar = ele.get(1).text();
				
				int solaryear = Integer.parseInt(sola.split(" ")[0].substring(0, 4));
				int solarmonth = Integer.parseInt(sola.split(" ")[1].substring(0, 2));
				int solardate = Integer.parseInt(sola.split(" ")[2].substring(0, 2));
				int lunaryear = Integer.parseInt(lunar.split(" ")[0].substring(0, 4));
				int lunarmonth = 0;
				try{ // 간혹 음력 월 앞에 '윤' 이라는 문자가 붙을 때를 위한 처리
					lunarmonth = Integer.parseInt(lunar.split(" ")[1].substring(0, 2));
				}catch (NumberFormatException e) {
					lunarmonth = Integer.parseInt(lunar.split(" ")[1].substring(1, 3));
				}
				int lunardate = Integer.parseInt(lunar.split(" ")[2].substring(0, 2));

				if (solardate == today) {
					calendarData = new DateData(solaryear, solarmonth, solardate, "today", null, lunaryear, lunarmonth, lunardate);
				} else {
					calendarData = new DateData(solaryear, solarmonth, solardate, "normal_date", null, lunaryear, lunarmonth, lunardate);
				}
				
				// todoList				
				cal.set(solaryear, solarmonth -1 , solardate);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String setdate = sdf.format(cal.getTime());
				todo.setSetdate(setdate);

				if (todo.getShareset() == null || todo.getShareset().trim().length() == 0) {
					calendarData.setTodoList(mapper.caltodolist(todo));
				} else {
					calendarData.setTodoList(mapper.caltodolistShareset(todo));
				}
				
				dateList.add(calendarData);
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// 달력 뒤 빈곳 빈 데이터 삽입
		int index = 7 - dateList.size() % 7;

		if (dateList.size() % 7 != 0) {

			for (int i = 0; i < index; i++) {
				calendarData = new DateData();
				dateList.add(calendarData);
			}
		}
		
		// 공휴일 & 대체 공휴일 지정
		try {
			for (int i=start - 1; i<endDate; i++) {
				cal.set(dateList.get(i).getYear(), dateList.get(i).getMonth()-1, dateList.get(i).getDate());
				if(dateList.get(i).getMonthLunar() == 1 && dateList.get(i).getDayLunar() == 1) {
					dateList.get(i - 1).setEvent("설날연휴");
					dateList.get(i).setEvent("설날");
					dateList.get(i + 1).setEvent("설날연휴");
					if(cal.get(Calendar.DAY_OF_WEEK) == 1 || cal.get(Calendar.DAY_OF_WEEK) == 7) {
						dateList.get(i + 2).setEvent("대체공휴일");
					}				
				} else if(dateList.get(i).getMonthLunar() == 4 && dateList.get(i).getDayLunar() == 8) {
					dateList.get(i).setEvent("석가탄신일");
				} else if(dateList.get(i).getMonthLunar() == 8 && dateList.get(i).getDayLunar() == 15) {
					dateList.get(i - 1).setEvent("추석연휴");
					dateList.get(i).setEvent("추석");
					dateList.get(i + 1).setEvent("추석연휴");
					if(cal.get(Calendar.DAY_OF_WEEK) == 1 || cal.get(Calendar.DAY_OF_WEEK) == 7) {
						dateList.get(i + 2).setEvent("대체공휴일");
					}
				} else if(dateList.get(i).getMonth() == 1 && dateList.get(i).getDate() == 1) {
					dateList.get(i).setEvent("신정");
				} else if(dateList.get(i).getMonth() == 3 && dateList.get(i).getDate() == 1) {
					dateList.get(i).setEvent("3.1절");
					if(cal.get(Calendar.DAY_OF_WEEK) == 1) {
						dateList.get(i + 1).setEvent("대체공휴일");
					} else if(cal.get(Calendar.DAY_OF_WEEK) == 7) {
						dateList.get(i + 2).setEvent("대체공휴일");
					} 
				} else if(dateList.get(i).getMonth() == 5 && dateList.get(i).getDate() == 1) {
					dateList.get(i).setEvent("근로자의날");
				} else if(dateList.get(i).getMonth() == 5 && dateList.get(i).getDate() == 5) {
					dateList.get(i).setEvent("어린이날");
					if(cal.get(Calendar.DAY_OF_WEEK) == 1) {
						dateList.get(i + 1).setEvent("대체공휴일");
					} else if(cal.get(Calendar.DAY_OF_WEEK) == 7) {
						dateList.get(i + 2).setEvent("대체공휴일");
					} 
				} else if(dateList.get(i).getMonth() == 6 && dateList.get(i).getDate() == 6) {
					dateList.get(i).setEvent("현충일");
				} else if(dateList.get(i).getMonth() == 8 && dateList.get(i).getDate() == 15) {
					dateList.get(i).setEvent("광복절");
					if(cal.get(Calendar.DAY_OF_WEEK) == 1) {
						dateList.get(i + 1).setEvent("대체공휴일");
					} else if(cal.get(Calendar.DAY_OF_WEEK) == 7) {
						dateList.get(i + 2).setEvent("대체공휴일");
					} 
				} else if(dateList.get(i).getMonth() == 10 && dateList.get(i).getDate() == 3) {
					dateList.get(i).setEvent("개천절");
					if(cal.get(Calendar.DAY_OF_WEEK) == 1) {
						dateList.get(i + 1).setEvent("대체공휴일");
					} else if(cal.get(Calendar.DAY_OF_WEEK) == 7) {
						dateList.get(i + 2).setEvent("대체공휴일");
					} 
				} else if(dateList.get(i).getMonth() == 10 && dateList.get(i).getDate() == 9) {
					dateList.get(i).setEvent("한글날");
					if(cal.get(Calendar.DAY_OF_WEEK) == 1) {
						dateList.get(i + 1).setEvent("대체공휴일");
					} else if(cal.get(Calendar.DAY_OF_WEEK) == 7) {
						dateList.get(i + 2).setEvent("대체공휴일");
					} 
				} else if(dateList.get(i).getMonth() == 12 && dateList.get(i).getDate() == 25) {
					dateList.get(i).setEvent("크리스마스");
				}
			}
		} catch (Exception e) {

		}
		return dateList;
	}
	
}
