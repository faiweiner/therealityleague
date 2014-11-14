$(document).ready(function () {
	if ($('#bracketBoard').length > 0) {
		console.log('Round Selection Board initialized');
		$availableContestantBoard = $('#availableContestant');
		$roundEditBoard = $('#roundEdit');

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

		var removeContestantFromRound = function (contestantId, originBoxNumber) {
			$recipientBox = $('#round');
			roundId = $recipientBox.data().roundId;

			$.ajax({
				url:	'/rounds/' +  roundId + '/remove/' + contestantId,
				type:	'POST',
				success: function (msg) {

				}
			}).done(function (response) {
				$contestantBox = $('.contestant'+contestantId);
				$contestantBox.empty();
			});
		};

		// ----- END server-side ----- //

		// ----- BEGIN client-side ----- //
		// detects which operation to execute
		var roundOperation = function (operation, contestantId, roundId) {

			switch (operation) {
				case 'add-round':
					addContestantToRound(contestantId, roundId);
					break;
				case 'remove-round':
					console.log('wanna remove?');
					// removeContestantFromRound(contestantId, roundId, originBoxNumber);
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
			};

			console.log($element);
			console.log("class " + myClass);
			console.log("contestant " + contestantId);
			console.log("box " + originBoxNumber);
			console.log("round " + roundId);

			roundOperation (operation, contestantId, roundId);
		});


	};
});