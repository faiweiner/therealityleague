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

		debugger
		// Client-side data
		var activeRoundId = $("li.btn-primary.selected").data().roundId;

		// Button changer
		$saveButton = $('#saveButton');

		$selectedRoundButton = $('.btn.btn-block.btn-sm.btn-primary.selected')
		var selectedRoundId = $selectedRoundButton.data().roundId;

		// ========== Begin server-side ========== //
		
		// --- adding/removing contestants from round by round ID --- //
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
			}).done(function (msg) {
				$roundEditBoard.html(msg);
				toggleRoundDisplay(roundId);
			});
		};

		// ========== END server-side ========== //

		// ========== BEGIN client-side ========== //

		// --- Retrieving round ID --- //
		var detectActiveRoundByElement = function (element) {
			var detectedActiveRoundId = element.dataset.roundId;
			return detectedActiveRoundId;
		};

		var detectActiveRoundByEnvironment = function () {
			var roundsDisplaysList = $('.round-display');
			for (var i = 0; i < roundsDisplaysList.length; i++) {
				if ($(roundsDisplaysList[i]).css('display') == 'block') {
					var activeRoundId = $(roundsDisplaysList[i]).data().roundId;
					return activeRoundId;
				};
			};
		};

		// --- Round Display Toggle --- //
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

		// toggle between episode buttons (make active)
		// function for element - click into element
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
			$siblings = $(searchTerm).siblings();
			$siblings.removeClass('btn-primary selected');
			$(element).addClass('btn-primary selected');
		};

		// function for ID - change from environment
		var toggleEpisodeButtonById = function (roundId) {
			var searchTerm = 'li.btn.btn-block'
			$siblings = $(searchTerm).siblings();
			var element;

			for (var i = 0; i < $siblings.length; i++) {
				if ($siblings[i].dataset.roundId == roundId) {
					element = $siblings[i];
				}
			}
			$siblings.removeClass('btn-primary selected');
			$(element).addClass('btn-primary selected');
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
			var activeRoundId = detectActiveRoundByEnvironment();
			var roundId;
			// sets operation based on myClass value

			switch (myClass) {
				case 'add-round glyphicon glyphicon-plus':
					var operation = 'add-round';
					roundId = activeRoundId;
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

		$bracketBoard.on('click', '.btn.btn-default.btn-xs.round-toggle', function (event) {
			// records which element is being clicked
			$element = event.target; 
			var targetRoundId = $element.dataset.roundId;
			toggleRoundDisplay(targetRoundId);
			toggleEpisodeButtonById($element.dataset.roundId);
		});

		// --- standard toggle to display --- //
		toggleRoundDisplay(activeRoundId);

	};
});