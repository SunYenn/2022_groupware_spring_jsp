<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="app_cancel_back">
	<div class="app_cancel_area">
	    <div class="result_area">
	        <h3>반려 사유</h3>
	        <div>
	            <textarea id="cancelReason" style="height: 250px; margin-top: 20px"></textarea>
	        </div>
	    </div>
	    <div class="button_area">
	        <button onclick="closeCancelForm()">닫기</button>
	        <button onclick="cancelAction()">확인</button>
	    </div>

	</div>
</div>

<div class="app_reason_back">
	<div class="app_reason_area">
	    <div class="result_area">
	        <h3>반려 사유</h3>
	        <div>
	            ${approval.appReason}
	        </div>
	    </div>
	    <div class="button_area">
	        <button onclick="closeAppReason()">닫기</button>
	    </div>

	</div>
</div>
<script>
(
	function () {
		var seq;
		var role;
		
		$(".app_cancel_back").hide();
		$(".app_cancel_area").hide();
		$(".app_reason_back").hide();
		$(".app_reason_area").hide();
	}
)

	function showCancelForm(seq, role) {
		this.seq = seq;
		this.role = role;
		
		const height = Math.floor($(".app_cancel_area").height());
		const scrollTop = Math.floor($("html").scrollTop() / 2);
		$(".app_cancel_back").css("top", height + scrollTop + 'px');
		
		$(".app_cancel_area").show();
		$(".app_cancel_back").show();
	}

	function cancelAction(){
		
		const data = $('#cancelReason').val();
		
	    if (confirm("정말 반려 처리하시겠습니까?")) {
	
	        if(role === 'A' || role === 'B' || role === 'C'){
	            const rolePath = role === 'A' ? 'appcanceled1' : role === 'B' ? 'appcanceled2' : 'appcanceled3';

 	            $.ajax({
	                type: "post",
	                url: "${path}/approval/" + rolePath,
	                data: {
	                	appNo : seq,
	                	appReason : data
	    			},
	                success: res => {
	                	
	                    let appendTag = '<img src="${path}/images/canceled.png" id="checkIfApproved"/>';
	                    
	                    if(role === 'A'){
	                        $("#firstA").append(appendTag);
	                        $('#Approver2').attr('disabled', true);
	                        $('#Approver3').attr('disabled', true);
	                    }
	                    if(role === 'B'){
	                        $("#interimA").append(appendTag);
	                        $('#Approver3').attr('disabled', true);
	                    } 
	                    if(role === 'C'){
	                        $("#finalA").append(appendTag);
	                    }
	                    Swal.fire({
	                        icon: 'success',
	                        title: '반려 처리했습니다.'
	                    }).then(function(){
	        				location.reload();
	        			});
	                },
	                error: function(){ alert("잠시 후 다시 시도해주세요."); }
	            }); 
 	           closeCancelForm();
	        }
	    }
	}

	function closeCancelForm(){
		$('#approvalSeq').val("");
		$('#cancelReason').val("");
		$('.app_cancel_area').hide();
		$('.app_cancel_back').hide();
	}
	
	function showAppReason() {
		const height = Math.floor($(".app_reason_area").height());
		const scrollTop = Math.floor($("html").scrollTop() / 2);
		$(".app_reason_back").css("top", height + scrollTop + 'px');
		
		$(".app_reason_back").show();
		$(".app_reason_area").show();
	}
	
	function closeAppReason() {
		$(".app_reason_back").hide();
		$(".app_reason_area").hide();
	}
</script>