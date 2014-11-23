$(document).ready(function () {
	if ($('#bracketBoard').length > 0) {
		console.log('Round Selection Board initialized');
		$availableContestantBoard = $('#availableContestant');
		$roundEditBoard = $('#roundEdit');
		$roundDisplayBoard = $('#roundDisplay');

		// Button changer
		$roundButtons = $('.btn.btn-default.btn-block.btn-sm');
		$saveButton = $('#saveButton');

		for (var i = 0; i < $roundButtons.length; i++) {
			var searchTerm = '#' + i
			$matchingButton = $(searchTerm);
			$buttonIndex = $matchingButton.data('index');
			if ($matchingButton.data('index') == $roundDisplayBoard.data().index) {
				console.log('found you!');
				$matchingButton.removeClass('btn-default');
				$matchingButton.addClass('btn-primary');
			};
		};

		// ----- Begin server-side ----- //
		
		var addContestantToRound = function (contestantId, roundId) {

			$.ajax({
				url: '/rounds/' + roundId + '/add/' + contestantId,
				type: 'POST',
				success: function (msg) {
				}
			}).done(function (response) {
				$roundEditBoard.empty();
				$availableContestantBoard.empty();
			})

		};

		var removeContestantFromRound = function (contestantId, roundId) {
			$.ajax({
				url:	'/rounds/' +  roundId + '/remove/' + contestantId,
				type:	'POST',
				success: function (msg) {

				}
			}).done(function (response) {
				$contestantBox.empty();
			});
		};

		// ----- END server-side ----- //

		// ----- BEGIN client-side ----- //
		// detects which operation to execute

		var removeContestantBox = function (contestantId) {

		};

		var roundOperation = function (operation, contestantId, roundId, element) {
			$element = element;
			var $parent = $element.parentElement.parentElement.parentElement.parentElement;

			if ($parent.className == "contestants-selected") {
				$parent.remove();
			}
		
			switch (operation) {
				case 'add-round':
					addContestantToRound(contestantId, roundId);
					break;
				case 'remove-round':
					removeContestantFromRound(contestantId, roundId);
					break;
				case 'save-next':
					goToNextRound(roundId);
					break;
			};
		};



		// ========= universal click listener ========= //
		$(this).on('click', function (event) {
			// records which element is being clicked
			$element = event.target;

			// set arguments for roundOperation
			var myClass = $element.className;
			var contestantId = $element.dataset.contestantId;
			var originBoxNumber = $element.dataset.originBoxNumber;
			var roundId = $roundEditBoard.data().roundId;
			// sets operation based on myClass value

			switch (myClass) {
				case 'add-round glyphicon glyphicon-plus':
					var operation = 'add-round';
					break;
				case 'remove-round glyphicon glyphicon-remove':
					var operation = 'remove-round';
					break;
				case 'saveButton':
					var operation = 'save-next';
					break;
			};

			console.log($element);
			console.log('class ' + myClass);
			console.log('contestant ' + contestantId);
			console.log('box ' + originBoxNumber);
			console.log('round ' + roundId);

			roundOperation (operation, contestantId, roundId, $element);
		});


	};
});