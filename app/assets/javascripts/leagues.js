$(document).ready(function () {
	$leagueCrationDiv = $('#league_creation');
	$leagueCommissionerOne = $('#comm-one');

	if ($leagueCrationDiv.length > 0) {
		console.log('Leagues JS for new league initiated');
		
		// set form variables
		$leagueNameInstruction = $('#league_name');
		$leagueShowInstruction = $('#league_show');		
		$leagueSeasonInstruction = $('#league_season');
		$leagueAccessInstruction = $('#league_access');		
		$leagueTypeInstruction = $('#league_type');
		$leagueScoringInstruction = $('#league_scoring');
		$leagueDeadlineInstructions = $('#league_deadline');
		$leagueDraftInput = $('#draft_type');
		$draftDatePicker = $('.draftDatePicker');
		$draftLimitField = $('#draftLimitField');

		// catch to only display popup explanation during league creation
		if ($('#popupDisabler').length === 0) {
			// Create new league function 
			$newLeagueForm = $('#new_league');

			$leagueNameInstruction.popover('hide');
			$leagueShowInstruction.popover('hide');
			$leagueSeasonInstruction.popover('hide');
			$leagueAccessInstruction.popover('hide');
			$leagueTypeInstruction.popover('hide');
			$leagueScoringInstruction.popover('hide');
			$leagueDeadlineInstructions.popover('hide');
			$leagueDraftInput.popover('hide');
			$draftDatePicker.popover('hide');
			$draftLimitField.popover('hide');
		}

		$leagueCrationDiv.cascadingDropdown({
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
				},		// end Step 2
				{
					selector: '.step3',
					paramName: 'leagueType',
					source: [
						{ label: 'Fantasy', value: 'Fantasy'},
						{ label: 'Bracket', value: 'Bracket'}
					],	// end source
					onChange: function (data, response) {
						var leagueType = response;
						console.log(leagueType);
						if (leagueType == 'Fantasy') {
							$draftDatePicker.attr('disabled', false);						
							$draftLimitField.attr('disabled', false);		
						} else if (leagueType == 'Bracket') {
							$draftDatePicker.attr('disabled', 'disabled');
							$draftLimitField.attr('disabled', 'disabled');
						};
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