package com.tjoeun.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tjoeun.dao.MyBatisDAO;
import com.tjoeun.service.GetList;

@Controller
public class Download {

	@RequestMapping("/Download/{folder}")
	public void download(@PathVariable("folder") String folder, HttpServletResponse response, HttpServletRequest request) throws IOException {

		String path = "D:\\upload\\" + folder + "\\";
		String filename = request.getParameter("filename");
		File file = new File(path + filename);

		byte b[] = null;

		try {
			b = FileUtils.readFileToByteArray(file);
			response.setContentType("application/download");
			response.setContentLength(b.length);
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", " "));
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.getOutputStream().write(b);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (IOException e) {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>alert('지금은 존재하지 않는 파일입니다.')</script>");
			out.println("<script>history.back(-1);</script>");
			out.flush();
		}

	}
	

}
