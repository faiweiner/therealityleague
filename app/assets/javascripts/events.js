$(document).ready(function () {
	$eventCreationDiv = $('#event_create');

	if ($eventCreationDiv.length > 0) {
		$eventCreationDiv.cascadingDropdown({
			selectBoxes: [
				// === begin Step 1 === //
				{
					// Populating .step 1 with list of shows and their IDs
					selector: '.step1',
					source: function(request, response) {
						$.getJSON('/api/shows', request, function (data) {
							response($.map(data.showsList, function (item, index) {
								return {
									label: item.name,
									value: item.id
								}
							}));
						});
					}  
				},  // end Step 1!
				// ==== begin Step 2 === //
				{
					selector: '.step2',
					requires: ['.step1'],
					paramName: 'showId',
					source: function (request, response) {
						$.getJSON('/api/seasons', request, function (data) {
							var selectOnlyOption = data.length <= 1;
							response($.map(data.seasonsList, function (item, index) {
								return {
										label: item.name,
										value: item.id,
										selected: selectOnlyOption // Select if only option
								};
							}));
						});
					} // end source for Step 2
				}, // end Step 2
				// ==== begin Step 3 === //				
				{


					selector: '.step3',
					requires: ['.step2'],
					paramName: 'seasonId',
					source: function (request, response) {
						var value = request.showId;
						request = 'season_list='+value;
						$.getJSON('/api/episodes', request, function (data) {
							var selectOnlyOption = data.length <= 1;
							response($.map(data.episodesList, function (item, index) {
								return {
										label: item,
										value: item,
										selected: selectOnlyOption // Select if only option
								};
							}));
						});
					} // end source for Step 2
				},	// end Step 3!
				{
					selector: '.step4',
					requires: ['.step3'],
					paramsName: 'boogyboogy',
					source: function (request, response) {

					}
				}
			] // end selectBoxes
		});
	}; // end IF statement $eventCreationDiv
});