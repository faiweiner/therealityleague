$(document).ready(function () {
	$pagesMarkerDiv = $('#first_time_user_prompt');
	if ($pagesMarkerDiv.length >= 1) {
		var $leaguesCount = $.getJSON('/', function (data) {
			$leaguesCount = data;
		})
		.done(function () {
			if ($leaguesCount === 0) {
				setTimeout(function (response) {
					$("#first_time_user_prompt").modal();
				}, 1000);				
			}
		});
		
		$modalDir1 = $('#modal-direction-1');
		$modalDir2 = $('#modal-direction-2');
		$modalDir3 = $('#modal-direction-3');
		
		$modalDirBtn1 = $('#modal-page-1');
		$modalDirBtn2 = $('#modal-page-2');
		$modalDirBtn3 = $('#modal-page-3');
	};

	var showPage = function (element, elementBtn) {
		element.removeClass('hidden');
		elementBtn.parent('li').addClass('active');
	};

	var hidePage = function (element, elementBtn) {
		element.addClass('hidden')
		elementBtn.parent('li').removeClass('active');
	};

	$modalDirBtn1.on('click', function () {
		showPage($modalDir1, $modalDirBtn1);
		hidePage($modalDir2, $modalDirBtn2);
		hidePage($modalDir3, $modalDirBtn3);
	});
	$modalDirBtn2.on('click', function () {
		hidePage($modalDir1, $modalDirBtn1);
		showPage($modalDir2, $modalDirBtn2);
		hidePage($modalDir3, $modalDirBtn3);
	});
	$modalDirBtn3.on('click', function () {
		hidePage($modalDir1, $modalDirBtn1);
		hidePage($modalDir2, $modalDirBtn2);
		showPage($modalDir3, $modalDirBtn3);
	});

});
