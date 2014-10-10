$(document).ready(function () {
	var $episodeCreationDiv = $('#episodeCreationDiv');
	if ($episodeCreationDiv.length > 0) {
		console.log('Episode JS for new episode initiated');
		$episodeCreationDiv.cascadingDropdown({
			selectBoxes: [
				// ===== begin Step 1 ===== //			
				{
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
				}, 	// end Step 1			
				// ===== begin Step 2 ===== //
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
					}
				}		// end Step 2
			]
		});
	}
})