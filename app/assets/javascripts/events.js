$(document).ready(function () {
	$eventCreationDiv = $('#event_create');

	if ($eventCreationDiv.length > 0) {
		$.ajax({
			url: 				'/api/shows',
			data: 			{format: 'js'},
			dataType: 	'json',
			success: function (data) {
				$exportShows = $.map(data.exportShows, function (item, index) {
					return {
						label: item.name,
						value: item.id
					}
				});
				$eventCreationDiv.cascadingDropdown({
					selectBoxes: [
						{
							selector: '.step1',
							source: $exportShows,
							onChange: function (event, value, requiredValue) {
								console.log(value);
								selectBoxes: [
									{
										selector: '.step2',
										requires: ['.step1'],
										paranName: 'showId',
										source: function (request, response) {
											$.getJSON('/api/seasons', request, function (data) {
												var selectOnlyOption = data.length <= 1;
												debugger
												response($.map(data.exportSeasons, function (item, index) {
													return {
														label: item.name,
														value: item.id,
														selected: selectOnlyOption
													}
												})); // end response
											}) // end .getJSON request
										}
									}
								] // end second selectBoxes
							} // end onChange function
						}, 		// end step1
						{
							selector: '.step2',
							requires: ['.step1'],
							paramName: 'showId',
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
								}); // end .getJSON
							}
						}		// end step2
					] // end selectBoxes
 				}) // end cascadingDropDown
			} // end ajax.success request
		}); // end AJAX request
	}; // end IF statement $eventCreationDiv
});