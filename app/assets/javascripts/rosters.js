$(document).ready(function () {
	// sets up the contestantBoard and rosterBoard
	$contestantBoard = $('#contestantBoard');
	$rosterBoard = $('#rosterBoard');


	// ================== GLOBAL FUNCTIONS ================== //

	// ----- BEGIN server-side ----- //
	// sends data to server for addition to roster
	var addContestantToRoster = function (contestantId, rosterId) {
		$.ajax({
			url: '/rosters/' + rosterId + "/add" + "/" + contestantId,
			type: 'POST',
			success: function (msg) {
				var partial = msg;
				$rosterBoard.html(partial);
			}
		});
	};

	// sends data to server for removal from roster
	var removeContestantFromRoster = function (contestantId, rosterId) {
		$.ajax({
			url: '/rosters/' + rosterId + "/remove" + "/" + contestantId,
			type: 'POST',
			success: function (msg) {
				var partial = msg;
				$contestantBoard.html(partial);
			}
		});
	};
	// ----- END server-side ----- //

	// ----- BEGIN client-side ----- //
	// detects which operation to execute
	var actionOperator = function (operation, contestantId, rosterId) {
		if (operation == 'add') {
			addContestantToRoster(contestantId, rosterId);
		} else if (operation == 'remove') {
			removeContestantFromRoster(contestantId, rosterId);
		};
	};

	// ========= universal click listener ========= //
	$(this).on('click', function (event) {

		// records which element is being clicked
		$element = event.target;

		// set arguments for actionOperator
		var myClass = $element.className;
		var contestantId = $element.dataset.contestantId
		var rosterId	= $element.dataset.rosterId

		// sets operation based on myClass value
		if (myClass == 'add-button fa fa-plus') {
			var operation = 'add';
			$element.offsetParent.remove();
		} else if (myClass == 'remove-button fa fa-times') {
			var operation = 'remove';
			$element.offsetParent.remove();
		};

		actionOperator(operation, contestantId, rosterId);
	});



	// $(function () {
	// 	console.log('Initialized old stuff');

	// 	// clicking add-button for available_contestants
	// 	$('.add-button').on('click', function () {
	// 		var operation = 'add'
	// 		var $clickedElement = $(this);
	// 		$contestantId = $clickedElement.data().contestantId;
	// 		$rosterId = $clickedElement.data().rosterId;
	// 		actionOperator(operation, $contestantId, $rosterId);
	// 		
	// 	});

	// 	// clicking remove-button	for selected_contestants
	// 	$('.remove-button').on('click', function () {
	// 		var operation = 'remove'
	// 		var $clickedElement = $(this);
	// 		$contestantId = $clickedElement.data().contestantId;
	// 		$rosterId = $clickedElement.data().rosterId;
	// 		actionOperator(operation, $contestantId, $rosterId);
	// 		$(this).closest('div.col-md-3').remove();
	// 	});
	// });

});