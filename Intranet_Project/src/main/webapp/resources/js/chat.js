window.onload = function(){
	
	let ip = window.location.host;
	let url = "ws://" + ip + "/Intranet_Project/chatserver"; // 채팅 서버 주소
	
	// 웹 소켓
	let ws;
	
	let btnConnect = document.querySelector('#btnConnect')
	let name = $('input#user').val().trim();
	let profile = $('#profile').val();
	let time = new Date().toLocaleTimeString();
	
	btnConnect.addEventListener('click', event => {
	
		 // 유저명 확인
		 if (name != '') {
			 // 연결
			 ws = new WebSocket(url);
			 
			 // 소켓 이벤트 매핑
			 ws.onopen = function (evt) {
				 console.log('서버 연결 성공');
				 print2(name, '님이 입장했습니다.');
				 
				 // 현재 사용자가 입장했다고 서버에게 통지(유저명 전달)
				 ws.send('1#' + name + '#' + profile);
				 
				 $('#btnConnect').attr('disabled', true);
				 $('#btnDisconnect').attr('disabled', false);
				 $('#msg').attr('disabled', false);
				 $('#msg').focus();
			 };
			 
			 ws.onmessage = function (evt) {
				 let data = evt.data;
				 
				 let no = data.split('#')[0]; 
				 let user = data.split('#')[1];
				 let profilename = data.split('#')[2];
				 let txt = data.split('#')[3];
				 
				 if (no == '1') {
					 print2(user);
				 } else if (no == '2') {
					 print(user, profilename, txt);
				 } else if (no == '3') {
					 print3(user);
				 }
				 
				$('#list').scrollTop($('#list').height());
				 
			 };
			 
			 ws.onclose = function (evt) {
				 console.log('소켓이 닫힙니다.');
				 print3(name)
			 };
			 
			 ws.onerror = function (evt) {
				 console.log(evt.data);
				 print3(name)
			 };
		 }
	});
		 
	// 다른 사람이 메시지 전송
	function print(user, profilename, txt) {
		let temp = '';
		
		temp += '<div class="chatText">';
		temp += 	'<img src="/profile/' + profilename + '">';
		temp += 	'<div>';
		temp += 		'<p>[' + user + ']<span>' + time  + '</span></p>';
		temp += 		'<span>' + txt + '</span>';
		temp += 	'</div>';
		temp += '</div>';
		 
		$('#list').append(temp);
	}
	
	// 내가 메시지 전송
	function printMe(user, txt) {
		let temp = '';
		
		temp += '<div class="chatText me">';
		temp += 	'<img src="/profile/' + profile + '">';
		temp += 	'<div>';
		temp += 		'<p><span>' + time + ' </span>[' + user + ']</p>';
		temp += 		'<span>' + txt + '</span>';
		temp += 	'</div>';
		temp += '</div>';
		
		$('#list').append(temp);
		$('#list').scrollTop($('#list').height());

	}
	
	// client 접속
	function print2(user) {
		let temp = '';
		temp += '<div class="chat_event">';
		temp += '[' + user + ']님이 접속했습니다. ';
		temp += '</div>';
		 
		$('#list').append(temp);
	}
		 
	// client 접속 종료
	function print3(user) {
		let temp = '';
		temp += '<div class="chat_event">';
		temp += "[" + user + "]님이 종료했습니다." ;
		temp += '</div>';
	 
		$('#list').append(temp);
		$('#list').scrollTop($('#list').height());
	}
 
	$('#msg').keydown(function() {
		if (event.keyCode == 13) {
		 
			// 서버에게 메시지 전달
			// 2#유저명#메시지
			ws.send('2#' + name + "#" + $(this).val()); // 서버에게
			printMe(name, $(this).val()); // 본인 대화창에
		 
			$('#msg').val('');
			$('#msg').focus();
		 
		}
	});
	 
	$('#btnDisconnect').click(function() {
		ws.send('3#' + name + '# ');
		ws.close();
		 
		$('#btnConnect').attr('disabled', false);
		$('#btnDisconnect').attr('disabled', true);
		 
		$('#msg').val('');
		$('#msg').attr('disabled', true);
	});
	
}

