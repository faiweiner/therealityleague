$(document).ready(function () {
	$eventCreationDiv = $('#event_create');

	if ($eventCreationDiv.length > 0) {
		$eventCreationDiv.cascadingDropdown({
			selectBoxes: [
				// === begin Step 1 === //
				{
					// Populating .step 1 with list of shows and their IDs
					selector: '.step1',
					paramName: 'showId',
					source: function(request, response) {
						$.getJSON('/api/shows', request, function (data) {
							response($.map(data.exportShows, function (item, index) {
								return {
									label: item.name,
									value: item.id
								}
							}));
						});
					}   // When user makes changes to step 1
					// onChange: function (event, value, requiredValues) {
					// 	selectBoxes: [{
					// 		selector: '.step2',
					// 		requires: ['.step1'],
					// 		paramName: 'showId',
					// 		source: function (request, response) {
					// 			$.getJSON('/api/seasons', request, function (data) {
					// 				var selectOnlyOption = data.length <= 1;
					// 				response($.map(data.exportSeasons, function (item, index) {
					// 					return {
					// 							label: item.name,
					// 							value: item.id,
					// 							selected: selectOnlyOption // Select if only option
					// 					};	// end return block
					// 				})); // end response block
					// 			});	// end getJSON for Step 2
					// 		}		// end source for Step 2
					// 	}]	// end selectBox for step 2
					// }		// end onChange for Step 1
				},  // end Step 1!
				// ==== begin Step 2 === //
				{
					selector: '.step2',
					requires: ['.step1'],
					paramName: 'seasonId',
					source: function (request, response) {
						$.getJSON('/api/seasons', request, function (data) {
							var selectOnlyOption = data.length <= 1;
							response($.map(data.exportSeasons, function (item, index) {
								return {
										label: item.name,
										value: item.id,
										selected: selectOnlyOption // Select if only option
								};
							}));
						});
					} // end source for Step 2
				}
			]	// end Step 2		
			selectBoxes: [
				{
					selector: '.step3',
					requires: ['step2'],
					paramName: 'episodeId',
					source: function (request, response) {
						$.getJSON('/api/seasons', request, function (data) {
							var selectOnlyOption = data.length <= 1;
							response($.map(data.exportSeasons, function (item, index) {
								return {
										label: item.name,
										value: item.id,
										selected: selectOnlyOption // Select if only option
								};
							}));
						});
					} // end source for Step 2
				}
			]
		});
	}; // end IF statement $eventCreationDiv
});