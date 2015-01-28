$(document).ready(function () {
	$eventCreationDiv = $('#event_create');
	if ($eventCreationDiv.length > 0) {
		$eventShowsDisplay = $('#event-show-displayed');
		$eventSeasonsDisplay = $('#event-season-displayed');
		$eventEpisodesDisplay = $('#event-episode-displayed');
		$eventContestantsDisplay = $('#event-contestant-displayed');
		$eventSchemesDisplay = $('#event-scheme-displayed');
		$eventEpisodeOptionsArea = $('#episode-options-area');
		$eventContestantOptionsArea = $('#contestant-options-area');
		$eventUpdate = $('#event-update');
		$targetEpisodeId = null;
		$targetContestantId = null;
		$targetSchemeId = null;

		var populateRecordedEvents = function (season_id, episode_id) {
			var url = '/events/display/' + season_id + '/' + episode_id;
			$.ajax({
				url: url,
				type: 'GET',
				success: function (result) {
					$eventUpdate.html(result);
				}
			});
		};

		// click detector for Show
		$eventShowsDisplay.on('click', '.show-option', function (event) {
			$eventShowsDisplay.children().removeClass('btn-primary selected');
			var target = event.target;
			$(target).addClass('btn-primary selected');			
			showId = event.target.dataset.showId;
			var request = 'show_id='+ showId;
			// get schemes
			$.getJSON('/api/schemes', request, function (data) {
				var options = $("#options");				
				for (var i = 0; i < data.schemeTypes.length; i++) {
					var button = $('<button/>');
					button.val(data.schemeTypes[i]);
					button.text(data.schemeTypes[i]);
					button.addClass('btn btn-default btn-sm');
					button.css('margin', '2px');
					$('#event-scheme-type-displayed').append(button);
				};
				for (var i = 0; i < data.schemesList.length; i++) {
					var option = $('<option/>');
					option.val(data.schemesList[i].id);
					option.text(data.schemesList[i].description);
					options.append(option);
				};
			});
		});

		// click detector for Season
		$eventSeasonsDisplay.on('click', '.season-option', function (event) {
			$eventSeasonsDisplay.children().removeClass('btn-primary');
			var target = event.target;
			$(target).addClass('btn-primary');
			seasonId = event.target.dataset.seasonId;
			var request = "season_id=" + seasonId;
			
			// list episodes
			$.getJSON('/api/episodes', request, function (data) {
				var episodesList = data.episodesList;
				$eventEpisodeOptionsArea.empty();
				for (var i = 0; i < episodesList.length; i++) {
					var episode = data.episodesList[i];
					$button = $('<input />');
					$button.attr('id', data.episodesList[i].id);
					$button.attr('data-season-id', data.episodesList[i].seasonId);
					$button.attr('data-episode-id', data.episodesList[i].id);
					$button.attr('name', 'event[episode_id]');
					$button.attr('type', 'button');
					$button.css('margin', '2px');
					$button.addClass('radio-button btn btn-sm btn-default episode-option');
					$button.val(episode.id);
					$button.text('hi');
					$eventEpisodeOptionsArea.append($button);
				};
			});
			
			// list contestants
			var seasonId = event.target.dataset.seasonId;
			$.getJSON('/api/contestants', request, function (data) {
				var contestantsList = data.contestantsList;
				$eventContestantOptionsArea.empty();
				for (var i = 0; i < contestantsList.length; i++) {
					var contestant = data.contestantsList[i];
					$button = $('<input />');
					$button.attr('data-contestant-id', data.contestantsList[i].id);
					$button.attr('name', 'event[contestant_id]');
					$button.css('margin', '2px');
					$button.addClass('btn btn-sm btn-default contestant-option');
					$button.val(contestant.name);
					$eventContestantOptionsArea.append($button);
				};				
			});
		});

		// click listener for Episode
		$eventEpisodesDisplay.on('click', '.episode-option', function (event) {
			$eventEpisodeOptionsArea.children().removeClass('btn-primary');
			var target = event.target;
			$(target).addClass('btn-primary');
			var episodeId = event.target.dataset.episodeId;
			$targetEpisodeId = episodeId;
			var seasonId = event.target.dataset.seasonId;
			// list currentEvents
			var data = populateRecordedEvents(seasonId, episodeId);
		});

		// click listener for Contestants
		$eventContestantsDisplay.on('click', '.contestant-option', function (event) {
			$eventContestantOptionsArea.children().removeClass('btn-primary');
			var target = event.target;
			$targetContestantId = target.dataset.contestantId;
			$(target).addClass('btn-primary');
		});

		// click listener for SUBMIT button
		$eventCreationDiv.on('click', '.actions', function (event) {
			$targetSchemeId = $('#options').val()
			var result;
			$.ajax({
				url: '/events',
				type: 'POST',
				dataType: 'JSON',
				data: { 
					'event': {
						contestant_id: 	$targetContestantId,
						episode_id: 		$targetEpisodeId,
						scheme_id:			$targetSchemeId
					}
				},
				success: function (response) {
					$oldAlert = $('#event-alert');
					$oldAlert.empty();
					$alert = $('<div>');
					$alert.addClass('alert ' + response.color);
					$alert.text(response.notice);
					$alert.appendTo($('#event-alert'));
				}
			}).done(function (response) {
				$eventTable = $('#episode-events-table');
				$firstEventRow = $('.event-row')[0];
				$newRow = $('<tr/>');
				$cell1 = $('<td/>');
				$cell1.text(response.newEvent[0]);
				$newRow.append($cell1);
				$cell2 = $('<td/>');
				$cell2.text(response.newEvent[1]);			
				$newRow.append($cell2);
				$cell3 = $('<td/>');
				$cell3.text(response.newEvent[2]);			
				$newRow.append($cell3);
				$cell4 = $('<td/>');
				$button1 = $('<a/>');
				$button2 = $('<a/>');
				$button1.text(response.newEvent[3][0]);
				$button2.text(response.newEvent[4][0]);
				$button1.addClass(response.newEvent[3][1]);
				$button2.addClass(response.newEvent[4][1]);
				$button1.attr('data-method', response.newEvent[3][2]);
				$button2.attr('data-method', response.newEvent[4][2]);
				$button1.attr('href', response.newEvent[3][3]);
				$button2.attr('href', response.newEvent[4][3]);
				$button1.attr('rel', response.newEvent[3][4]);
				$button2.attr('rel', response.newEvent[4][4]);
				$cell4.append($button1);
				$cell4.append($button2);
				$newRow.append($cell4);
				var newRow = $newRow[0];
				$(newRow).insertBefore($firstEventRow);
			});
		});

				
	}; // end IF statement $eventCreationDiv
});