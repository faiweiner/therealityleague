$(document).ready(function () {
	console.log('Events initialized');

	// ----- DEFAULTS for inline-editing ----- //


	$newEventForm = $('#new-event');
	$newEventSubmitButton = $('#new-event-submit');
	$eventsTable = $('.events-table');

	// ================== IN-LINE EDITING ================== //
	$('#accordion').find('.btn-primary').hide();

	$.extend($.fn.editable.defaults, defaults);


	// ================== GLOBAL FUNCTIONS ================== //

	// ----- BEGIN server-side ----- //
	// sends data to server for addition to events
	var addEventToShow = function () {
		$.ajax({
			url: '/events/',
			type: 'POST',
			success: function () {
				window.location.reload(true);
			}
		});
	};

	// sends data to server for removal from roster
	var removeEventFromShow = function (contestantId, rosterId) {
		$.ajax({
			url: '/rosters/' + rosterId + "/remove" + "/" + contestantId,
			type: 'POST',
			success: function (msg) {
				var partial = msg;
				$contestantBoard.html(partial);
			}
		});
	};

	// sends data to server for removal from roster
	var updateEvent = function (contestantId, rosterId) {
		$.ajax({
			url: '/rosters/' + rosterId + "/remove" + "/" + contestantId,
			type: 'POST',
			success: function (msg) {
				var partial = msg;
				$contestantBoard.html(partial);
			}
		});
	};
	// ----- END server-side ----- //

	$newEventSubmitButton.on('click', function () {
		addEventToShow();
	});
});