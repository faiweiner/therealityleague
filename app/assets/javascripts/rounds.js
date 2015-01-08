$(document).ready(function () {
	if ($('#bracketBoard').length > 0) {
		console.log('Round Selection Board initialized');
		$bracketBoard = $('#bracketBoard');								// overaching DIV covering the below
		$availableContestantBoard = $('#availableContestant');
		$roundEditBoard = $('#roundEdit');
		$episodeBoard = $('#episodeBoard');

		// Server data
		var roundsCount = $('#episodeBoard').data().roundsCount;
		var roundsIds = $('#episodeBoard').data().roundsIds;

		// Client-side data
		var activeRoundId = $("li.btn-primary.selected").data().roundId;

		// Button changer
		$saveButton = $('#saveButton');


		$selectedRoundButton = $('.btn.btn-block.btn-sm.btn-primary.selected')
		var selectedRoundId = $selectedRoundButton.data().roundId;
		// ----- Begin server-side ----- //
		
		var addContestantToRound = function (contestantId, roundId) {
			$.ajax({
				url: '/rounds/' + roundId + '/add/' + contestantId,
				type: 'POST',
				success: function (msg) {
				}
			}).done(function (msg) {			
				$roundEditBoard.html(msg);
				toggleRoundDisplay(roundId);
			});
		};

		var removeContestantFromRound = function (contestantId, roundId) {
			$.ajax({
				url:	'/rounds/' +  roundId + '/remove/' + contestantId,
				type:	'POST',
				success: function (msg) {
				}
			}).done(function (response) {
	
			});
		};

		var goToNextRound = function (roundId) {
			$.ajax({
				url:	'/rounds/round/' + roundId + '/save',
				type:	'GET',
				success: function (msg) {

				}
			});
		};
		// ----- END server-side ----- //

		// ----- BEGIN client-side ----- //

		// hides all round display except the active one
		var toggleRoundDisplay = function (activeRoundId) {
			for (var i = 0; i < roundsCount; i++) {
				var searchTerm = '#' + roundsIds[i]
				var roundDisplay = $(searchTerm);
				if (roundsIds[i] == activeRoundId) {
					$activeRoundDisplay = $(searchTerm);
					$activeRoundDisplay.show();
				} else {
					$inactiveRoundDisplay = $(searchTerm);
					$inactiveRoundDisplay.hide();
				}
			}
		};

		var toggleEpisodeButton = function (element) {
			var classList = element.classList;
			var searchTerm = 'li'
			for (var i = 0; i < classList.length; i++) {
				switch (classList[i]) {
					case 'btn':
						searchTerm += '.' + classList[i]
						break;
					case 'btn-block':
						searchTerm += '.' + classList[i]
						break;
				}
			}
			console.log(searchTerm);
			$siblings = $(searchTerm).siblings();
			console.log($siblings);
			console.log(element);
			$siblings.removeClass('btn-primary', 'selected');
			$(element).addClass('btn-primary');

		};


		var detectActiveRound = function (roundId) {
			var $siblings = $( "li.btn.btn-block" ).siblings();
			$siblings.removeClass('btn-primary', 'selected');
			$element.classList.add('btn-primary', 'selected');
			selectedRoundId = roundId;
			return selectedRoundId;
		};
		// detects which operation to execute

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
			}
		};

		// ========= universal click listeners ========= //

		// // --- for adding/removing contestants from Round --- //
		$bracketBoard.on('click', $('.glyphicon'), function (event) {
			// records which element is being clicked
			$element = event.target;
			// set arguments for roundOperation
			var myClass = $element.className;
			var contestantId = $element.dataset.contestantId;
			var originBoxNumber = $element.dataset.originBoxNumber;
			var roundId;
			// sets operation based on myClass value

			switch (myClass) {
				case 'add-round glyphicon glyphicon-plus':
					var operation = 'add-round';
					roundId = selectedRoundId;
					break;
				case 'remove-round glyphicon glyphicon-remove':
					var operation = 'remove-round';
					roundId = $element.dataset.roundId;
					break;
			};
			roundOperation (operation, contestantId, roundId, $element);
		});
		

		// --- for selecting Round --- //

		$episodeBoard.on('click', '.btn.btn-block.btn-sm', function (event) {
			// records which element is being clicked
			$element = event.target; 
			var roundId = $element.dataset.roundId;
			toggleRoundDisplay(roundId);
			toggleEpisodeButton($element);
		});

		$bracketBoard.on('click', '.btn.btn-default.btn-sm.round-toggle', function (event) {
			// records which element is being clicked
			$element = event.target; 
			console.log($element);
			var targetRoundId = $element.dataset.roundId;
			toggleRoundDisplay(targetRoundId);
		});

		// --- standard toggle to display --- //
		toggleRoundDisplay(activeRoundId);
	};
});