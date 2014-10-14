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

		// ----- CLIENT-SIDE ----- //
		// function for removing
		$('.glyphicon-remove').hover(
			function () {
				$(this).css('-webkit-transform', 'scale(1.1)');
			}, function () {
				$(this).css('-webkit-transform', 'scale(1.0)');
			}
		).click(function(event) {
			rosterId = event.target.dataset.rosterId;
			contestantId = event.target.dataset.contestantId;
		});

		// function for adding contestant
		$('.glyphicon-ok').hover(
			function () {
				$(this).css('-webkit-transform', 'scale(1.1)');
			}, function () {
				$(this).css('-webkit-transform', 'scale(1.0)');
			}
		).click(function(event) {
			rosterId = event.target.dataset.rosterId;
			contestantId = event.target.dataset.contestantId;
		});
	}
});