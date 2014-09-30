$(document).ready(function () {
	$leagueCrationDiv = $('#league_creation');
	if ($leagueCrationDiv.length === 0) {
		return
	};
	console.log('Leagues JS file executed');
	// catch to only display popup explanation during league creation
	if ($('#popupDisabler').length === 0) {
		// Create new league function 
		$newLeagueForm = $('#new_league');
		$leagueNameInput = $('#league_name');
		$leagueTypeInput = $('#league_type');
		$leagueScoringInput = $('#league_scoring');
		$leagueDraftInput = $('#draft_type');

		$leagueNameInput.popover('hide');
		$leagueTypeInput.popover('hide');
		$leagueScoringInput.popover('hide');
		$leagueDraftInput.popover('hide');
	}

	$('#league_creation').cascadingDropdown({
		selectBoxes: [
			{
				selector: '.step1',
				source: function(request, response) {
					$.getJSON('/leagues/new', request, function (data) {
						response($.map(data.exportShows, function (item, index) {
							return {
								label: item.name,
								value: item.id
							}
						}));
					});
				},
				onChange: function (event, value, requiredValues) {
					console.log(value);
					console.log(requiredValues);
					selectBoxes: [
						{
							selector: '.step2',
							requires: ['.step1'],
							paramName: 'showId',
							source: function (request, response) {
								$.getJSON('/leagues/new', request, function (data) {
									var selectOnlyOption = data.length <= 1;
									response($.map(data.exportSeasons, function (item, index) {
										return {
												label: item.name,
												value: item.id,
												selected: selectOnlyOption // Select if only option
										};
									}));
								});
							}
						}
					]
				}
			},
			{
				selector: '.step2',
				requires: ['.step1'],
				paramName: 'showId',
				source: function (request, response) {
					$.getJSON('/leagues/new', request, function (data) {
						var selectOnlyOption = data.length <= 1;
						response($.map(data.exportSeasons, function (item, index) {
							return {
									label: item.name,
									value: item.id,
									selected: selectOnlyOption // Select if only option
							};
						}));
					});
				}
			}
		]
	});
});