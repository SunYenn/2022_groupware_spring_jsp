// 창 열기
function pmPop(empno, name) {

	$('.transpm').css('display', 'block');
	$('.pmback').css('display', 'block');

	$('#pmreceiver').val(name + '(' + empno + ')');
	$('#pmtitle').val('');
	$('#pmcontent').val('');
	$('#pmfilename').val('');
	
	window.onkeyup = function(e) {
		if(e.keyCode == 27) {
			closePmPop();
		}
	};
}

// 창 닫기
function closePmPop() {
	$('.transpm').css('display', 'none');
	$('.pmback').css('display', 'none');

}

//내게 쓰기
function transeme(emp) {
	$('input[name=emplist]').val(emp.split('(')[1].split(')')[0]);
	$('input[name=empsearch]').val(emp);
	$('input[name=empsearch]').attr('disabled', true);
	$('.receive_list > span').remove();
	$('button[name=transemebtn]').attr('onclick', 'transemecancle("' + emp + '")');
	$('button[name=transemebtn]').html("쪽지 쓰기");
}

// 내게 쓰기 취소
function transemecancle(emp) {
	$('input[name=emplist]').val('');
	$('input[name=empsearch]').val('');
	$('input[name=empsearch]').attr('disabled', false);
	$('button[name=transemebtn]').attr('onclick', 'transeme("' + emp + '")');
	$('button[name=transemebtn]').html("내게 쓰기");
}

// 받는 사람 자동완성
function searchemp() {
	let data = $('input[name=empsearch]').val();	
	let me = $('input[name=transeempno]').val();	
	
	if (data.length != 0) {
		$.ajax({
			type: 'POST',
			url: '/Intranet_Project/mypage/searchemp',
			data: {
				searchname : data,
				empno : me
			},
			success: res => {
				let i = 0;
				let list = $(res).find('ArrayList').children();
				
				$('.msg_dropdown > p').remove();
				
				while (i != list.length) {
					let empno = $(list[i]).children().eq(0).text();
					let name = $(list[i++]).children().eq(1).text();
					let data = name + "(" + empno + ")";
					$('.msg_dropdown').css('display', 'block');
					$('.msg_dropdown').append('<p onclick="appendemp(\'' + name + '\',\'' + empno + '\')">' + data + '</p>');
				};
				
			},
			error: err => console.log('검색 실패' + err)
		});
	}
}

// 받는 사람 추가
function appendemp(name, empno) {
	$('.msg_dropdown > p').remove();
	$('.receive_list').css('display', 'flex');
	$('.receive_list').append('<span value = "' + empno + '">' + name + '<a onclick = "removeemp(this)">X</a></span>')
	let field = $('input[name=emplist]');	
	if (field.val().length != 0) { 
		field.val( field.val() + ',' + empno);
	} else {
		field.val(empno);
	}
	$('input[name=empsearch]').val('');	
	$('input[name=empsearch]').focus();	
}

// 받는 사람 삭제
function removeemp(obj) {
	$(obj).parent().remove();
	let str = $('input[name=emplist]').val();
	let remove = $(obj).parent().attr("value");
	if (str.search(remove) == 0) {
		str = str.replace(remove, '').replace(',','');
	}else {str = str.replace(',' + remove, '')}
	str = str.replace(/,$/, '')
	$('input[name=emplist]').val(str);
}

// 파일 첨부시 선택 파일명 표시
$("#filename").on('change', function() {
	var fileName = $("#filename").val().split('\\')[2];
	$("#selectfile").html(fileName + "<a onclick='removefile()'>X</a>");
});

// 파일 첨부 삭제
function removefile(){
	$("#filename").val('');
	$("#selectfile").html('');
}

// 쪽지 전송 유효성 검사
function check_form() {
	
	if ($('input[name=emplist]').val()) {
		if ($('input[name=emplist]').val().length == 0) {
			alert('받는사람이 지정되지 않았습니다.')
			return false
		}
	} else if ($('input[name=title]').val().trim().length == 0) {
		alert('제목을 입력해주세요.')
		return false
	} else if ($('textarea[name=content]').val().trim().length == 0) {
		alert('내용을 입력해주세요.')
		return false
	}
	return true
}