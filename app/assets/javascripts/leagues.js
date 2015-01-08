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
		$participantCapField = $('#participantCapField');
		$participantCapInput = $('#participantCap');
		$leagueDraftInput = $('#draft_type');
		$draftDatePickerField = $('#draftDatePickerField');
		$draftDateLabel = $('#draftDateLabel');
		$draftDateInput = $('#draftDateInput');
		$draftLimitField = $('#draftLimitField');

		$seasonContestantCount = $('#seasonContestantCount');
		$contestantLimitBox = $('#contestantLimitBox');
		var contestantCount = 0;
		var contestantLimitNum = 0;
		var premiereDate;

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
			$draftDatePickerField.popover('hide');
			$draftLimitField.popover('hide');
		}

		$leagueCrationDiv.cascadingDropdown({
			selectBoxes: [
				// ===== begin Step 1 ===== //
				{
					selector: '.step1',
					source: function(request, response) {
						$.getJSON('/api/shows', request, function (data) {
							var selectOnlyOption = data.length <= 1;
							response($.map(data.showsList, function (item, index) {
								return {
									label: item.name,
									value: item.id,
									selected: selectOnlyOption // Select if only option
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
								contestantCount = item.contestantCount;
								premiereDate = item.premiereDate;
								return {
										label: 	item.name,
										value: 	item.id,
										selected: selectOnlyOption // Select if only option
								};
							}));
						});
					}, // end source
					onChange: function (data, response) {
						$seasonContestantCount.children().children().find('span').text(contestantCount);
						$draftLimitField.find('#draftLimit').val(contestantLimitNum);
						console.log(premiereDate);
					}
				},		// end Step 2
				{
					selector: '.step3',
					paramName: 'leagueType',
					source: [
						{ label: 'Fantasy', value: 'Fantasy'},
						{ label: 'Elimination', value: 'Elimination'}
					],	// end source
					onChange: function (data, response) {
						var leagueType = response;
						console.log(leagueType);
						if (leagueType == 'Fantasy') {
							$participantCapField.removeClass('hidden');
							$contestantLimitBox.removeClass('hidden');
						} else if (leagueType == 'Elimination') {
							$participantCapField.addClass('hidden');
							$contestantLimitBox.addClass('hidden');
						};
					}
				},		// end Step 3
				{
					selector: '.step4',
					paramName: 'participantCap',
					onChange: function (data, response) {
						contestantLimitNum = Math.floor(contestantCount / parseInt(response));
						$contestantLimitBox.children().children().find('span').css('font-weight:bold');
						$contestantLimitBox.children().children().find('span').text(contestantLimitNum);
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