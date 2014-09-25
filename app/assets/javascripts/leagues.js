$(document).ready(function () {
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
});