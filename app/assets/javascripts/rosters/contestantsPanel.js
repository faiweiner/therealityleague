$(document).ready(function () {
	if ($('.contestants-panel').length > 0) {
		console.log('Roster Selection Board initialized')

		$contestantBoard = $('#contestantBoard');
		// ----- SERVER-SIDE ----- //
		// sends data to server for addition to roster
		var addContestantToRoster = function (contestantId, rosterId) {
			$.ajax({
				url: '/rosters/' + rosterId + '/add' + '/' + contestantId,
				type: 'POST',
				success: function (msg) {
					$contestantBoard.html(msg);
				}
			});
		};

		var removeContestantFromRoster = function (contestantId, rosterId) {
			$.ajax({
				url: '/rosters/' + rosterId + '/remove' + '/' + contestantId,
				type: 'POST',
				success: function (msg) {
					$contestantBoard.html(msg);
				}
			});
		};

		// ----- CLIENT-SIDE ----- //
		// function for removing contestant

		$(this).on('click', '.glyphicon', function (event) {
			var myClass = event.target.className;
			contestantId = event.target.dataset.contestantId;
			rosterId = event.target.dataset.rosterId;

			if (myClass == 'add-button glyphicon glyphicon-ok') {
				console.log('adding');
				addContestantToRoster(contestantId, rosterId);
			} else if (myClass == 'remove-button glyphicon glyphicon-remove') {
				console.log('removing');
				removeContestantFromRoster(contestantId, rosterId);
			} else {
				return
			};
		});

		$('.remove-button.glyphicon-remove').hover(
			function () {
				$(this).css('-webkit-transform', 'scale(1.1)');
			}, function () {
				$(this).css('-webkit-transform', 'scale(1.0)');
			}
		);
		

		// function for adding contestant
		$('.add-button.glyphicon-ok').hover(
			function () {
				$(this).css('-webkit-transform', 'scale(1.1)');
			}, function () {
				$(this).css('-webkit-transform', 'scale(1.0)');
			}
		);
	}
});