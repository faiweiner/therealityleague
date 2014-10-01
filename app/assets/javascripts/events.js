$.ajax({
	url: '/events',
	data: {format: 'js'},
	dataType: 'json',
	success: function (data) {
		$(document).ready(function () {
			console.log('events ready');
			console.log(data.exportShows);
			$eventCreationDiv = $('#event_create');
			// if ($eventCreationDiv.length > 0) {
			// 	$eventCreationDiv.cascadingDropdown({
			// 		selectBoxes: [
			// 			{
			// 				selector: '.step1',
			// 				source: function(request, response) {
			// 					$.getJSON('/events/new', request, function (data) {
			// 						response($.map(data.exportShows, function (item, index) {
			// 							return {
			// 								label: item.name,
			// 								value: item.id
			// 							}
			// 						}));
			// 					});
			// 				},
			// 				onChange: function (event, value, requiredValues) {
			// 					console.log(value);
			// 					console.log(requiredValues);
			// 					selectBoxes: [
			// 						{
			// 							selector: '.step2',
			// 							requires: ['.step1'],
			// 							paramName: 'showId',
			// 							source: function (request, response) {
			// 								$.getJSON('/leagues/new', request, function (data) {
			// 									var selectOnlyOption = data.length <= 1;
			// 									response($.map(data.exportSeasons, function (item, index) {
			// 										return {
			// 												label: item.name,
			// 												value: item.id,
			// 												selected: selectOnlyOption // Select if only option
			// 										};
			// 									}));
			// 								});
			// 							}
			// 						}
			// 					]
			// 				}
			// 			},
			// 			{
			// 				selector: '.step2',
			// 				requires: ['.step1'],
			// 				paramName: 'showId',
			// 				source: function (request, response) {
			// 					$.getJSON('/leagues/new', request, function (data) {
			// 						var selectOnlyOption = data.length <= 1;
			// 						response($.map(data.exportSeasons, function (item, index) {
			// 							return {
			// 									label: item.name,
			// 									value: item.id,
			// 									selected: selectOnlyOption // Select if only option
			// 							};
			// 						}));
			// 					});
			// 				},
			// 				onChange: function (event, value, requiredValues) {
			// 				}
			// 			}
			// 		]
			// 	});




			// }
		});
		
	}
});
