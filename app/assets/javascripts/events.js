$(document).ready(function () {
	$eventCreationDiv = $('#event_create');

	if ($eventCreationDiv.length > 0) {
		$eventCreationDiv.cascadingDropdown({
			selectBoxes: [
				// === begin Step 1 for SHOWS === //
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
				},	// end Step 3!
				// ==== begin Step 4 for CONTESTANTS === //						
				{
					selector: '.step4',
					requires: ['.step2'],
					paramName: 'seasonId',
					source: function (request, response) {
						var value = request.showId;
						request = 'season_list='+value;
						$.getJSON('/api/contestants', request, function (data) {
							var selectOnlyOption = data.length <= 1;
							response($.map(data.contestantsList, function (item, index) {
								return {
										label: item.name,
										value: item.id,
										selected: selectOnlyOption // Select if only option
								};
							}));
						});

					}
				},	// end Step 4!
				{
					selector: '.step5',
				},
				// ==== begin Step 6 for SCHEMES === //			
				{
					selector: '.step6',
					requires: ['.step1','.step5'],
					requireAll: true,
					paramName: 'showId',
					source: function (request, response) {
						$.getJSON('/api/schemes', request, function (data) {
							var selectOnlyOption = data.length <= 1;
							response($.map(data.schemesList, function (item, index) {
								var schemeName = item.type + ": " + item.description
								return {
									label: schemeName,
									value: item.id,
									selected: selectOnlyOption
								}
							}));	// end response block
						}) 
					}	// end source block
				} 	// end Step 6!
			] // end selectBoxes
		});
	}; // end IF statement $eventCreationDiv
});