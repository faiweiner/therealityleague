$(document).ready(function () {
	$eventCreationDiv = $('#event_create');
	if ($eventCreationDiv.length > 0) {
		$eventCreationDiv.cascadingDropdown({
			selectBoxes: [
				{
					selector: '.step1',
					source: function (response) {
						$.ajax({
							url: 'api/show',
							data: {format: 'js'},
							success: function (data) {
								response($.map(data.exportShows, function (item, index) {
									return {
										label: item.name,
										value: item.id
									}
								}))
							}
						})
					}
				},
				{
						selector: '.step2',
						requires: ['.step1'],
						source: function(request, response) {
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
						}
				}
				// {
				//     selector: '.step3',
				//     requires: ['.step1', '.step2'],
				//     requireAll: true,
				//     source: function(request, response) {
				//         $.getJSON('/api/storages', request, function(data) {
				//             response($.map(data, function(item, index) {
				//                 return {
				//                     label: item + ' GB',
				//                     value: item,
				//                     selected: index == 0 // Select first available option
				//                 };
				//             }));
				//         });
				//     },
				//     onChange: function(event, value, requiredValues){
				//         // do stuff
				//     }
				// }
			]
		});
	}
});

// $.ajax({
// 	url: '/api/show',
// 	data: {format: 'js'},
// 	dataType: 'json',
// 	success: function (data) {
// 		$(document).ready(function () {
// 			console.log('events ready');
			
// 			 {
// 				$eventCreationDiv.cascadingDropdown({
// 					selectBoxes: [
// 						{
// 							selector: '.step1',
// 							source: function (data) {
// 								data($.map(data.exportShows, function (item, index) {
// 									return {
// 										label: item.name,
// 										value: item.id
// 									}
// 								}));
// 							},
// 							onChange: function (event, value, requiredValues) {
// 								console.log(value);
// 							}
// 						}
// 					]
// 				})
// 			}
// 		});
		
// 	}
// });
