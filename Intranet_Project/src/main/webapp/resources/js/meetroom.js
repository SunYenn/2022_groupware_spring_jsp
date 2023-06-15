var start = document.getElementsByName('starttime')[0];
var end = document.getElementsByName('endtime')[0];

$(start).timepicker({
	timeFormat : 'HH:mm',
	interval : 15,
	startTime : '00:00',
	dynamic : false,
	dropdown : true,
	scrollbar : true,
	change : setMinTime
});

$(end).timepicker({
	timeFormat : 'HH:mm',
	interval : 15,
	dynamic : false,
	dropdown : true,
	scrollbar : true,
});

function setMinTime() {

	var setTime = $('#starttime').val()

	$(end).timepicker('option', 'minTime', setTime + 30);
	if ($('#endtime').val() && $('#endtime').val() < setTime) {
		$(end).timepicker('setTime', setTime + 30);
	}
}

function checkTime() {

	var setSTime = document.getElementsByClassName('setStime');
	var setETime = document.getElementsByClassName('setEtime');

	var sTime = $('#starttime').val()
	var eTime = $('#endtime').val()

	if (setSTime.length > 0) {
		for (i = 0; i < setSTime.length; i++) {
			
			startTime = setSTime[i].innerText;
			endTime = setETime[i].innerText;
			
			if (sTime > startTime && sTime < endTime || eTime > startTime && eTime < endTime) {
				alert('이미 예약된 시간입니다.')
				return false;
			}
		}
		if (sTime == eTime) {
			alert('시간 설정이 잘못됐습니다.')
			return false;
		}
	
	}
	
	return True;
}
