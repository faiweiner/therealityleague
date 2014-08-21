$(document).ready(function () {
	// sets up the contestantBoard and rosterBoard
	$contestantBoard = $('#contestantBoard');
	$rosterBoard = $('#rosterBoard');

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

	// detects which operation to execute
	var actionOperator = function (operation, contestantId, rosterId) {
		if (operation == 'add') {
			addContestantToRoster(contestantId, rosterId);
		} else if (operation == 'remove') {
			removeContestantFromRoster(contestantId, rosterId);
		};
	};

	console.log('this page is bomb');

	// universal click listener
	$(this).on('click', function (event) {
		
		// records which element is being clicked
		$element = event.target;
		var myClass = $element.className;
		console.log($element);
		console.log(myClass);

		if (myClass == 'add-button fa fa-plus') {
			var operation = 'add';
			console.log('im about to add');
		} else if (myClass == 'remove-button fa fa-times') {
			var operation = 'remove';
			console.log('im about to remove');
		};
	});


	$(function () {
		console.log('Initialized');

		// clicking add-button for available_contestants
		$('.add-button').on('click', function () {
			var operation = 'add'
			var $clickedElement = $(this);
			$contestantId = $clickedElement.data().contestantId;
			$rosterId = $clickedElement.data().rosterId;
			actionOperator(operation, $contestantId, $rosterId);
			$(this).closest('div.col-md-5').remove();
		});

		// clicking remove-button	for selected_contestants
		$('.remove-button').on('click', function () {
			var operation = 'remove'
			var $clickedElement = $(this);
			$contestantId = $clickedElement.data().contestantId;
			$rosterId = $clickedElement.data().rosterId;
			actionOperator(operation, $contestantId, $rosterId);
			$(this).closest('div.col-md-3').remove();
		});
	});

});