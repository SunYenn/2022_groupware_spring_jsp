<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>

	<div class="inserttodoback">
		<div class="inserttodo">
		
			<div class="top">
				<p class="top1">일정 등록</p>
				<p class="top2" onclick="closeInsertTodo()">X</p>
			</div>
			
			<div class="middle">
				<form>
					<table>
						<tr>
							<th>종료 시간</th>
							<td><input id="endtime" type="time"/></td>
						</tr>
						<tr>
							<th>내용</th>
							<td><input id="content" type="text" /></td>
						</tr>
						<tr>
							<th>공개여부</th>
							<td>
								<select id="shareset">
									<option value="NO">비공개</option>
									<optgroup label="공개">
										<option value="ALL">전체</option>
										<option value="TEAM">팀</option>
									</optgroup>
								</select>
							</td>
						</tr>
						<tr>
							<th>배경색</th>
							<td>
								<select id="colorcode" name="colorcode" onchange="changeBack()">
									<option value="">메모의 배경을 설정합니다.</option>
									<option style="background: #FFFFFF">#FFFFFF</option>
									<option style="background: #E8F3D6">#E8F3D6</option>
									<option style="background: #FFE5F1">#FFE5F1</option>
									<option style="background: #FAAB78">#FAAB78</option>
									<option style="background: #FFF6C3">#FFF6C3</option>
									<option style="background: #F8F988">#F8F988</option>
									<option style="background: #CCD6A6">#CCD6A6</option>
									<option style="background: #ADE792">#ADE792</option>
									<option style="background: #68B984">#68B984</option>
									<option style="background: #D2DAFF">#D2DAFF</option>
									<option style="background: #B4CDE6">#B4CDE6</option>
									<option style="background: #82C3EC">#82C3EC</option>
									<option style="background: #F3CCFF">#F3CCFF</option>
									<option style="background: #D09CFA">#D09CFA</option>
									<option style="background: #D0B8A8">#D0B8A8</option>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="right">
								<input type="button" value="취소" onclick="closeInsertTodo()" /> 
								<input type="button" value="등록" onclick="todoinsert(${todayData.year},${todayData.month},${todayData.date})" />
							</td>
						</tr>
					</table>
					<input type="hidden" id="todoempno" value="${EmpVO.empno}" />
				</form>
			</div>
		</div>
	</div>

</body>
</html>