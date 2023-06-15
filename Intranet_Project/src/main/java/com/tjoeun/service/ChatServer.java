package com.tjoeun.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/chatserver")
public class ChatServer {

	// 현재 채팅 서버에 접속한 클라이언트(WebSocket Session) 목록 static 붙여야함!!
	private static List<Session> list = new ArrayList<Session>();

	private void print(String msg) {
		System.out.printf("[%tT] %s\n", Calendar.getInstance(), msg);
	}

	@OnOpen
	public void handleOpen(Session session) {
		print("클라이언트 연결");
		list.add(session); // 접속자 관리(****)
	}
	
	private String profile = "";

	@OnMessage
	public void handleMessage(String msg, Session session) {

		// 로그인할 때: 1#유저명
		// 대화 할 때: 2유저명#메세지
		
		String no = msg.split("#")[0];
		String user = msg.split("#")[1];
		String txt = msg.split("#")[2];

		if (no.equals("1")) {
			
			// 누군가 접속 > 1#아무개
			profile = txt; // 접속할때 txt에 저장되는 profile 데이터를 전역변수에 저장
			
			for (Session s : list) {
				if (s != session) { // 현재 접속자가 아닌 나머지 사람들
					try {
						s.getBasicRemote().sendText("1#" + user);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}

		} else if (no.equals("2")) {
			// 누군가 메세지를 전송
			for (Session s : list) {

				if (s != session) { // 현재 접속자가 아닌 나머지 사람들
					try {
						s.getBasicRemote().sendText("2#" + user + "#" + profile + "#" + txt);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			
		} else if (no.equals("3")) {
			// 누군가 종료 > 3#아무개
			for (Session s : list) {

				if (s != session) { // 현재 접속자가 아닌 나머지 사람들
					try {
						s.getBasicRemote().sendText("3#" + user);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			list.remove(session);
		}

	}

	@OnClose
	public void handleClose() {
		print("클라이언트 연결 종료");
	}

	@OnError
	public void handleError(Throwable t) {
		System.out.println("handleError");
		System.out.println(t);
	}

}