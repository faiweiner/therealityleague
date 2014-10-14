$(document).ready(function () {
	if ($('.contestants-panel').length > 0) {
		console.log('Roster Selection Board initialized')

		// ----- SERVER-SIDE ----- //
		// sends data to server for addition to roster
		var addContestantToRoster = function (contestantId, rosterId) {
			$.ajax({
				url: '/rosters/' + rosterId + '/add' + '/' + contestantId,
				type: 'POST',
				success: function (msg) {
					partial = msg;
				}
			}).done(function (data) {
				debugger
			});
		};

		var removeContestantFromRoster = function (contestantId, rosterId) {
			$.ajax({
				url: '/rosters/' + rosterId + '/remove' + '/' + contestantId,
				type: 'POST',
				success: function (msg) {
					var partial = msg;
					$contestantBoard.html(partial);
				}
			});
		};

		// ----- CLIENT-SIDE ----- //
		// function for removing
		$('.glyphicon-remove').hover(
			function () {
				$(this).css('-webkit-transform', 'scale(1.1)');
			}, function () {
				$(this).css('-webkit-transform', 'scale(1.0)');
			}
		).click(function (event) {
			contestantId = event.target.dataset.contestantId;
			rosterId = event.target.dataset.rosterId;

			removeContestantFromRoster(contestantId, rosterId);
		});
		// function for adding contestant
		$('.glyphicon-ok').hover(
			function () {
				$(this).css('-webkit-transform', 'scale(1.1)');
			}, function () {
				$(this).css('-webkit-transform', 'scale(1.0)');
			}
		).click(function (event) {
			contestantId = event.target.dataset.contestantId;
			rosterId = event.target.dataset.rosterId;

			// passing client-side variables to the server
			addContestantToRoster(contestantId, rosterId);
		});
	}
});