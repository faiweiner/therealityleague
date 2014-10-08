$(document).ready(function () {
	$leagueCrationDiv = $('#league_creation');
	$leagueCommissionerOne = $('#comm-one');

	if ($leagueCrationDiv.length > 0) {
		console.log('Leagues JS for new league initiated');
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

		$leagueCrationDiv.cascadingDropdown({
			selectBoxes: [
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
							}
						]
					}
				},
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
					},
					onChange: function (event, value, requiredValues) {
					}
				}
			]
		});
	} else if ($leagueCommissionerOne.length > 0) {
		console.log('Leagues JS for viewing a league initiated');
		var getUrlParameter = function () {
			var sPageURL = window.location.pathname;
			var sURLVariables = sPageURL.split('/');
			for (var i = 0; i < sURLVariables.length; i++) {
				var sParameterName = sURLVariables[i];
				if ($.isNumeric(sParameterName) == true) {
					return sParameterName;
				}
			}
		};   

		var leagueUrl = '/leagues/' + getUrlParameter();

		var participantCount = 0;
		var leagueShowData = $.ajax({
			url: leagueUrl,
			data: {format: 'js'},
			dataType: 'json',
			success: function (data) {
				participantCount = data.exportParticipants.length;
			}
		})
		.done(function () {
			if (participantCount <= 1) {
				setTimeout(function (response) {
					$('#participants_prompt').modal();
				}, 1000);			
			};
		});

	} else {}
		$('.participants_prompt').hide();
	;


});