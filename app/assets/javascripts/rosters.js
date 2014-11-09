$(document).ready(function () {

	if ($('#contestantBoard').length > 0) {
		console.log('Rosters for contestant board initialized');
		// sets up the contestantBoard and rosterBoard
		$contestantBoard = $('#contestantBoard');
		$rosterBoard = $('#rosterBoard');
		$rosterCountDisplay = $('#rosterCountDisplay');
		// ================== GLOBAL FUNCTIONS ================== //

		// ----- BEGIN server-side ----- //
		// sends data to server for addition to roster
		var addContestantToRoster = function (contestantId, rosterId) {
			$.ajax({
				url: '/rosters/' + rosterId + '/add' + '/' + contestantId,
				type: 'POST',
				success: function (msg) {
					var partial = msg;
					$rosterBoard.html(partial);
				}
			}).done(function (data) {

				// Getting contestant count for roster
				$.get( "/rosters/" + rosterId + "/current", function (data) {
				}, 'json')
				.done(function (data) {
					var contestantsCount = data.contestantsCount;
					var leagueLimit = data.leagueLimit;
				});
			});
		};

		// sends data to server for removal from roster
		var removeContestantFromRoster = function (contestantId, rosterId) {
			$.ajax({
				url: '/rosters/' + rosterId + '/remove' + '/' + contestantId,
				type: 'POST',
				success: function (msg) {
					var partial = msg;
					$contestantBoard.html(partial);
				}
			});

			// Getting contestant count for roster
			var contestantsCount = $.get( '/rosters/' + rosterId + '/current', function (data) {
				contestantsCount = data ;
			}, 'json');

			// refreshing roster board
			$.ajax({
				url: '/rosters/' + rosterId + '/current',
				type: 'GET',
				success: function (msg) {
					var partial = msg;
					$rosterBoard.html(partial);
				}
			});	
		};


		var addContestantToRound = function (contestantId, rosterId, originBoxNumber) {

			$recipientBox = $('#round')
			$.ajax({
				url: '/rounds',
				data: { 
					roster_id: rosterId,
					origin_box_number: originBoxNumber
				},
				dataType: 'JSON'
			}).done(function (response) {
				var roundId = response.round.id;
				$.ajax({
					url: '/rounds/' + roundId + '/add/' + contestantId,
					type: 'POST',
					success: function (msg) {
					}
				}).done(function (response) {
					$contestantBox = $('.contestant'+contestantId);
					$contestantBox.empty();
				})
			});
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
		var rosterOperator = function (operation, contestantId, rosterId, originBoxNumber) {

			switch (operation) {
				case 'add-roster':
					addContestantToRoster(contestantId, rosterId);
					break;
				case 'remove-roster':
					removeContestantFromRoster(contestantId, rosterId);
					break;
				case 'add-bracket':
					addContestantToRound(contestantId, rosterId, originBoxNumber);
					break;
				case 'remove-bracket':
					removeContestantFromRound(contestantId, originBoxNumber);
					break;
			};
		};

		// ========= universal click listener ========= //
		$(this).on('click', function (event) {
			// records which element is being clicked
			$element = event.target;
			// set arguments for rosterOperator
			var myClass = $element.className;
			var contestantId = $element.dataset.contestantId;
			var rosterId	= $element.dataset.rosterId;
			var originBoxNumber = $element.dataset.originBoxNumber;
			// sets operation based on myClass value

			switch (myClass) {
				case 'add-button glyphicon glyphicon-plus':
					var operation = 'add-roster';
					break;
				case 'remove-button glyphicon glyphicon-remove':
					var operation = 'remove-roster';
					break;
				case 'add-bracket glyphicon glyphicon-arrow-right':
					var operation = 'add-bracket';
					break;
				case 'remove-bracket glyphicon glyphicon-remove':
					var operation = 'remove-bracket';
					break;
			};

			rosterOperator(operation, contestantId, rosterId, originBoxNumber);

		});

	} else if ($('#contestants-display').length > 0) {
		setTimeout(function () {
			$('#participants_prompt').modal();
		}, 1000);
	};

});