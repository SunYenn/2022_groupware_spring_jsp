// 데이터 유효성 검사 ///////////////////////////////////////////////////////////////////////////////////////////////

// 비밀번호 검사
function passwordCheckFunction() {
	
	let password1 = $('#password1').val();
	let password2 = $('#password2').val();

	let pcm = $('#pwCheckMessage');
	
	// 비밀번호 영문자, 숫자, 특수문자를 모두 포함해야 한다.
	let reg = /^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[~?!@#$%^&*_-]).{4,16}$/;
	
	// 비밀번호 4자리 이상 16자리 이하로 설정하는 조건 (최대길이 조건 register.jsp 파일 => maxlength)
	if (password1.length < 4) {
		pcm.html('비밀번호는 4~16자로 설정해야 합니다.');
		$('.change').attr("disabled",true);
	} else if (!reg.test(password1)) {
		pcm.html('비밀번호는 영문자,숫자,특수문자를 모두 포함해야 합니다.');
		$('.change').attr("disabled",true);
	} else if (password1 != password2) {
		pcm.html('비밀번호가 일치하지 않습니다.');
		$('.change').attr("disabled",true);
	} else {
		pcm.html(' ');
		$('.change').attr("disabled",false);
	}
}

// 이름 정규식
function nameCheckFunction() {
	let name = $('#name').val();
	let pcm = $('#nameCheckMessage');
	let reg = /^[가-힣|a-z|A-Z]+$/;
	
	if (!reg.test(name)) {
		pcm.html('이름은 한글 또는 영문만 작성하세요.')
		$('.change').attr("disabled",true);
	} else {
		pcm.html(' ');
		$('.change').attr("disabled",false);
	}
}

// 휴대폰번호 정규식
function pernumCheckFunction(obj) {
	var v = obj.value;
	obj.value = v.replace(/[^0-9]/g, "")
				.replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3")
				.replace("--", "-"); 
}

// 이메일 정규식
function emailCheckFunction() {
	let email = $('#email').val();
	let pcm = $('#emailCheckMessage');
	let reg = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	
	if (!reg.test(email)) {
		pcm.html('이메일을 (@ 포함) 올바르게 입력하세요.');
		$('.change').attr("disabled",true);
	} else {
		pcm.html(' ');
		$('.change').attr("disabled",false);
	}
}

// 회원가입 ///////////////////////////////////////////////////////////////////////////////////////////////

//아이디 중복검사
function registerCheckFunction() {
	let empno = $('#empno').val().trim();
	
	$.ajax({
		type: 'POST',
		url: './UserRegisterCheck',
		data: {
			empno: empno
		},
		
		success: res => {
			switch (res) {
				case "1":
					alert('아이디를 입력하세요.')
					break;
				case "2":
					alert('이미 사용중인 아이디입니다.')
					break;
				case "3":
					alert('5자리의 숫자를 입력해주세요.')
					break;
				case "4":
					alert('사용 가능한 아이디입니다.')
					break;
			}
		},
		error: err => console.log('register.js의 아이디 중복확인 Ajax 요청 실패' + err)
	});
}

// ajax, 회원가입 실행 함수
function userRegister() {
	let empno = $('#empno').val();
	let password1 = $('#password1').val();
	let password2 = $('#password2').val();
	let name = $('#name').val();
	let pernum = $('#pernum').val();
	let gender = $('input[name=gender]:checked').val();
	let email = $('#email').val();
	
	// jQuery Ajax
	$.ajax({
		type: 'POST',
		url: './UserRegister',
		data: {
			empno: empno,
			password1: password1,
			password2: password2,
			name: name,
			pernum: pernum,
			gender: gender,
			email: email
		},
		success: res => {
		// 성공
			$('#empno').val('');
			$('#password1').val('');
			$('#password2').val('');
			$('#name').val('');
			$('#pernum').val('');
			$('#email').val('');
			
			switch (res) {
				case '1':
					alert('모든 내용을 입력하세요.')
					break;
				case '2':
					alert('비밀번호가 일치하지 않습니다.')
					break;
				case '3':
					alert('회원가입에 성공했습니다.')
					location.replace('login');
					break;
				case '4':
					alert('회원가입 실패')
					break;
			}
		},
		error: err => console.log('회원가입 요청 실패' + err)
	});
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//로그인 폼 검사
function checkLogin() {
	
	let empno = document.getElementsByName('empno')[0].value;
	let pswd = document.getElementsByName('password')[0].value;

	if(empno == null || empno == "") {
		alert('아이디(사원번호)를 입력해주세요.');
		return false;
	} 
	
	if( pswd == null || pswd == "") {
		alert('비밀번호를 입력해주세요.');
		return false;
	} 
	
	localStorage.setItem("count", 1800);
	return true;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//아이디 찾기
function findID() {
	let idf = document.findIDForm;
	let name = idf.name.value;
	let pernum = idf.pernum.value;
	
	if (name.length == 0) {
		alert('이름을 입력해주세요.');
		return
	} else if (pernum.length == 0) {
		alert('전화번호를 입력해주세요.');
		return
	}
	
	$.ajax({
		type: 'POST',
		url: '/Intranet_Project/findID',
		data: {
			name : name,
			pernum : pernum
		},
		success: res => {
			if(res.length == 0) {
				alert('존재하지 않는 회원정보입니다.');
				return
			} else {
				$('.findIDForm').append('<p style="color: #1C658C;">아이디(사원번호) : ' + res + '</p>');
			}
		},
		error: err => console.log('아이디 찾기 실패' + err)
	});
	
}

//비밀번호 찾기
function findPW() {
	let idf = document.findPWForm;
	let empno = idf.empno.value;
	let name = idf.name.value;
	let pernum = idf.pernum.value;
	
	if (empno.length == 0) {
		alert('사원번호를 입력해주세요.');
		return
	} else if (empno.length != 5) {
		alert('사원번호는 5자리입니다.');
		return
	}else if (name.length == 0) {
		alert('이름을 입력해주세요.');
		return
	} else if (pernum.length == 0) {
		alert('전화번호를 입력해주세요.');
		return
	}
	
	$.ajax({
		type: 'POST',
		url: '/Intranet_Project/findPW',
		data: {
			empno : empno,
			name : name,
			pernum : pernum
		},
		success: res => {
			if(res.length == 0) {
				alert('존재하지 않는 회원정보입니다.');
				return
			} else {
				$('.findPWForm').append('<p style="color: #1C658C;">비밀번호 : ' + res + '</p>');
			}
		},
		error: err => console.log('아이디 찾기 실패' + err)
	});
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//비밀번호 변경 창 열기
function changePop() {
    $('.pwchange').css('display','block');
    $('.background').css('display','block');
    $('#checkPassword').val('');
    $('#password1').val('');
    $('#password2').val('');
    $('#passwordCheckMessage').html(' ');
    
	window.onkeyup = function(e) {
		if(e.keyCode == 27) {
			closePop();
		}
	};
}

// 비밀번호 변경 창 닫기
function closePop() {
    $('.pwchange').css('display','none');
    $('.background').css('display','none');
}

// ajax, 현재 비밀번호 검사, 비밀번호 변경
function changePassword() {
   let empno = $('#empno').val();
   let password = $('#password').val();
   let checkPassword = $('#checkPassword').val();
   let password1 = $('#password1').val();
   
   if(checkPassword.length == 0) {
	   alert('현재 비밀번호를 입력해주세요.');
	   return;
   }
   
   if(password != checkPassword) {
	   alert('현재 비밀번호가 틀렸습니다.');
	   return;
   }

   $.ajax ({
      type: 'POST',
      url: './UserRegisterUpdate',
      data:{
         empno: empno,
         password: password1
      },
      success: res => {
           alert('비밀번호 변경 완료')
           $('.pwchange').css('display','none');
           $('.background').css('display','none');
           location.reload();
      },
      error : e => console.log('변경 실패 : ',e.status)
   });
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//프로필 이미지 등록 창 열기
function openProfilePop() {
    $('.profileback').css('display','block');
    $('.profilediv').css('display','block');
    
    $('#proimg').attr('src', $('#PROFILENAME').val());
    $('#profilename').val('');
    
	window.onkeyup = function(e) {
		if(e.keyCode == 27) {
			closeProfilePop();
		}
	};
}

//프로필 이미지 등록 창 닫기
function closeProfilePop() {
	$('.profileback').css('display','none');
    $('.profilediv').css('display','none');
}

//프로필 이미지 미리보기
function showImg() {	
	
	var reader = new FileReader();

    reader.onload = function(event) {
    	let fileType = event.target.result;
    	
    	if(!fileType.includes('image')) {
    		alert('해당 파일은 이미지 파일이 아닙니다.');
    		$('#proimg').attr('src', $('#PROFILENAME').val());
    		$('#profilename').val('');
    		return
    	}
    	$('#proimg').attr('src', event.target.result);
    };
    
    reader.readAsDataURL(event.target.files[0]);
}

