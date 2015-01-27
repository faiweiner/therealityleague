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
					$button.attr('data-episode-id', data.episodesList[i].id);
					$button.attr('data-season-id', data.episodesList[i].seasonId);
					$button.attr('name', 'event[episode_id]');
					$button.css('margin', '2px');
					$button.addClass('btn btn-sm btn-default episode-option');
					$button.val(episode.airDate);
					$eventEpisodeOptionsArea.append($button);
				};

			});
			
			// list contestants
			var seasonId = event.target.dataset.seasonId;
			$.getJSON('/api/contestants', request, function (data) {
				var contestantsList = data.contestantsList;
				// $eventContestantOptionsArea.empty();
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
			var showId = $eventShowsDisplay.children('.btn-primary').data().showId;
			var contestantId = $eventContestantOptionsArea.children('.btn-primary').data().contestantId;
			var episodeId = $eventEpisodeOptionsArea.children('.btn-primary').data().contestantId;
		});

				
	}; // end IF statement $eventCreationDiv
});