$(document).ready(function () {

	if ($('#contestantBoard').length > 0) {
		console.log('Rosters for contestant board initialized');
		// sets up the contestantBoard and rosterBoard
		$rosterBoard = $('#roster-board');
		$contestantBoard = $('#contestantBoard');
		$rosterCountDisplay = $('#rosterCountDisplay');
		// ================== GLOBAL FUNCTIONS ================== //

		// ----- BEGIN server-side ----- //
		// sends data to server for addition to roster
		var addContestantToRoster = function (contestantId, rosterId) {
			$.ajax({
				url: '/rosters/' + rosterId + '/add' + '/' + contestantId,
				type: 'POST',
				success: function (msg) {
				}
			}).done(function (msg) {
				$rosterBoard.html(msg);
			});
		};

		// sends data to server for removal from roster
		var removeContestantFromRoster = function (contestantId, rosterId) {
			$.ajax({
				url: '/rosters/' + rosterId + '/remove' + '/' + contestantId,
				type: 'POST',
				success: function (msg) {
				}
			}).done(function (msg) {
				$rosterBoard.html(msg);
			});
		};

		// ----- END server-side ----- //

		// ----- BEGIN client-side ----- //
		// detects which operation to execute
		var rosterOperator = function (operation, contestantId, rosterId) {
			console.log(operation, contestantId, rosterId);
			switch (operation) {
				case 'add-roster':
					addContestantToRoster(contestantId, rosterId);
					break;
				case 'remove-roster':
					removeContestantFromRoster(contestantId, rosterId);
					break;
			};
		};

		// ========= universal click listener ========= //

		// HOVER listener
		$rosterBoard.on({
			mouseenter: function () {
				$(this).find('.thumbnail.contestant-thumbnail');
				$(this).toggleClass('hover');
				var $thumbnailFamily;
				$thumbnailFamily = $(this).children();
				$actionPanel = ($thumbnailFamily[3]);
				$actionPanel.setAttribute('style','display:block');
				},
			mouseleave: function () {
				$(this).find('.thumbnail.contestant-thumbnail');
				$(this).toggleClass('hover');
				$thumbnailFamily = $(this).children();
				$actionPanel = ($thumbnailFamily[3]);
				$actionPanel.setAttribute('style','display:none');
				}
		},'.thumbnail.contestant-thumbnail');

		$rosterBoard.on('click', $('i.glyphicon'), function (event) {
			// records which element is being clicked
			$element = event.target;

			// set arguments for rosterOperator
			var myClass = $element.className;
			var contestantId = $element.dataset.contestantId;
			var rosterId	= $element.dataset.rosterId;

			// sets operation based on myClass value

			switch (myClass) {
				case 'glyphicon glyphicon-ok':
					var operation = 'add-roster';
					break;
				case 'glyphicon glyphicon-remove':
					var operation = 'remove-roster';
					break;
			};

			rosterOperator(operation, contestantId, rosterId);

		});

	} else if ($('#contestants-display').length > 0) {
		setTimeout(function () {
			$('#participants_prompt').modal();
		}, 1000);
	};

});