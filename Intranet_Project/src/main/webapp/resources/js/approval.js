// 결재서 작성 유효성 검사
function check_onclick() {
				
	if($('input[name=firstApproverName]').val() == null || $('input[name=firstApproverName]').val().trim() == "") {
		alert('최초승인자가 선택되지 않았습니다. 확인 후 등록하세요.');
		return false;
	}
	
	if($('input[name=interimApproverName]').val() == null || $('input[name=interimApproverName]').val().trim() == "") {
		alert('중간승인자가 선택되지 않았습니다. 확인 후 등록하세요.');
		return false;
	}
	
	if($('input[name=finalApproverName]').val() == null || $('input[name=finalApproverName]').val().trim() == "") {
		alert('최종승인자가 선택되지 않았습니다. 확인 후 등록하세요.');
		return false;
	}
	
	if ($('#loaContent').val().trim() == "" || $('#loaTitle').val().trim() == "") {
		alert('상세내용 또는 제목란이 비어있습니다. 확인 후 등록하세요.');
		return false;
	}
	
	if ($('#proposerText').val().trim() == "") {
		alert('결재서명 후 \n결재를 진행해주세요.');
		return false;
	}
	
	return true;
}

// 결재서 작성 본인 서명
$("#proposer").on("click",function(){
	var proposerValue = $("input[name='writeName']").val();

	$("#proposerText").append(proposerValue);
});

// 최초 승인자 서명
function Approver1(obj, appNO){
	
	$.ajax({
		type: 'POST',
		url: '/Intranet_Project/approval/loaApproved1?appNo='+appNO,
		success: res => {
			Swal.fire({
				icon: 'success',
     			title: '결재서명이 \n완료되었습니다.'
			}).then(function(){
				location.reload();
			});
			$('#firstA').append('<img src="/Intranet_Project/images/approved.png" id="checkIfApproved" />');
			$('#Approver1').attr('disabled', true);
		}, error: err => alert("잠시 후 다시 시도해주세요.")
	});
	
}

// 중간 승인자 서명
function Approver2(obj, appNO){
	
	$.ajax({
		type: 'POST',
		url: '/Intranet_Project/approval/loaApproved2?appNo='+appNO,
		success: res => {
			Swal.fire({
				icon: 'success',
     			title: '결재서명이 \n완료되었습니다.'
			}).then(function(){
				location.reload();
			});
			$('#interimA').append('<img src="/Intranet_Project/images/approved.png" id="checkIfApproved" />');
			$('#Approver2').attr('disabled', true);
		}, error: err => alert("잠시 후 다시 시도해주세요.")
	});

}

// 최종 승인자 서명
function Approver3(obj, appNO){
	
	$.ajax({
		type: 'POST',
		url: '/Intranet_Project/approval/loaApproved3?appNo='+appNO,
		success: res => {
			Swal.fire({
				icon: 'success',
     			title: '결재서명이 \n완료되었습니다.'
			}).then(function(){
				location.reload();
			});
			$('#finalA').append('<img src="/Intranet_Project/images/approved.png" id="checkIfApproved" />');
			$('#Approver3').attr('disabled', true);
		}, error: err => alert("잠시 후 다시 시도해주세요.")
	});

}


