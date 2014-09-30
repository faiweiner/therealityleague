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

	var seasonList = [];
	var showList = [];
	
	$.ajax({
		type: "GET",
		url: "/leagues/new",
		dataType: "json",
		success: function (data) {
			for (var i = 0; i < data.exportSeasons.length; i++) {
				seasonList.push(
					{ name: 		data.exportSeasons[i].name, 
						id: 			data.exportSeasons[i].id, 
						show_id: 	data.exportSeasons[i].show_id 
					}
				);
			};
			for (var i = 0; i < data.exportShows.length; i++) {
				showList.push(
					{ name: 		data.exportShows[i].name, 
						id: 			data.exportShows[i].id
					}
				);
			};
		}
	});

	$('#league_creation').cascadingDropdown({
		selectBoxes: [
			{
				selector: '.step1',
				source: [
					{ label: '4.0"', value: 4 },
					{ label: '4.3"', value: 4.3 },
					{ label: '4.7"', value: 4.7 },
					{ label: '5.0"', value: 5 }
				]
			},
			{
				selector: '.step2',
				requires: ['.step1'],
				source: function (request, response) {
					$.getJSON('/api/resolutions', request, function(data) {
						var selectOnlyOption = data.length <= 1;
						response($.map(data, function(item, index) {
							return {
									label: item + 'p',
									value: item,
									selected: selectOnlyOption // Select if only option
							};
						}));
					});
				},
				onChange: function (event, value, requiredValues) {
					// do stuff
				}
			}
		]
	});
});