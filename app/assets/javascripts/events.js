$(document).ready(function () {
	$eventCreationDiv = $('#event_create');
	$refreshArea = $('#event-form-refresh');
	if ($eventCreationDiv.length > 0) {
		$eventCreationDiv.cascadingDropdown({
			selectBoxes: [
				// === begin Step 1 for SHOWS === //
				{
					// Populating .step 1 with list of shows and their IDs
					selector: '.step1',
					source: function(request, response) {
						$.getJSON('/api/shows', request, function (data) {
							debugger
							response($.map(data.showsList, function (item, index) {
								return {
									label: item.name,
									value: item.id
								}
							}));
						});
					}  
				},  // end Step 1!
				// ==== begin Step 2 for SEASONS=== //
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
				// ==== begin Step 3 for EPISODES === //				
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
								var episodeName = item.name + " - " + item.airDate;
								return {
										label: episodeName,
										value: item.id,
										selected: selectOnlyOption // Select if only option
								};
							}));
						});
					} // end source for Step 2
				}	// end Step 3!
			] // end selectBoxes
		});
		$('.step1').on('change', function (event) {
			var showId = event.delegateTarget.value;
			request = showId;
			$.getJSON('/api/schemes', request, function (data) {
				debugger
			});
		});
		// console.log($refreshArea);
		// $('.step2').on('change', function (event) {
		// 	console.log('why would you change me?');
		// 	var season = event.delegateTarget.value;
		// 	request = 'season_list=' + seasonId;
		// 	$.getJSON('/api/contestants', request, function (data) {
		// 		debugger
		// 	});
		// });

	}; // end IF statement $eventCreationDiv
});