$(document).ready(function () {

	if ($('#manage-events').length == 0) {
		return;
	};
	console.log('Events initialized');

	$newEventForm = $('#new-event');
	$newEventSubmitButton = $('#new-event-submit');
	$eventsBoard = $('#events-board');
	$eventsDisplayBox = $('#events-display-box');
// ================== IN-LINE EDITING ================== //

	$.extend($.fn.editable.defaults, defaults);

	$eventsDisplayBox.find('span[data-name="type"]').editable({
		// title: 'Enter type',
		// tpl: "<input type='text' style='width: 100px'>"
	});

	$('#event-display-box span[data-name="event"]').editable({
		// title: 'Enter event',
		// tpl: "<input type='text' style='width: 100px'>"
	});

	$('#event-display-box span[data-name="points_asgn"]').editable({
		title: 'Enter points',
		tpl: "<input style='width: 100px'>"
	});

	$('#event-display-box').on('click', '.edit', function (){
		$('#event-display-box').find('.editable-open').editable('hide');
		$('#event-display-box').find('.btn-primary').hide();
		$('#event-display-box').find('.edit').show();
		$(this).hide().siblings('.btn-primary').show();
		$(this).closest('tr').find('.editable').editable('show');
	});

	$('#event-display-box').on('click', '.save', function() {
		var $btn = $(this);
		var eventId = jQuery(this).closest('tr').find('span')[0].dataset.pk;
		$.ajax({
			url: '/events/' + eventId,
			type: 'POST',
			responseTime: 200,
			response: function(settings) {
				console.log(settings.data);   
		 	}
			// success: function (msg) {
			// 	var partial = msg;
			// 	$rosterBoard.html(partial);
			// }
		});

		$btn.closest('tr').find('.editable').editable('hide');
		$btn.hide().siblings('.edit').show();
	});

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

	var hideActionButtons = function () {
		$eventsBoard.find('.save').hide();
		$eventsBoard.find('.destroy').hide();
	};

	var showActionButtons = function () {
		$eventsDisplayBox.find('.edit').hide();
		$eventsDisplayBox.find('.save').show();
		$eventsDisplayBox.find('.destroy').show();
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

	var populateEventsTable = function (show_id) {
		console.log(show_id);
		$.ajax({
			url: '/events/' + show_id,
			type: 'GET',
			success: function (msg) {
				var partial = msg;
				$eventsBoard.html(partial);
				hideActionButtons();
			}
		});
		console.log('got here');
	};

	// ----- END server-side ----- //

	$newEventSubmitButton.on('click', function () {
		addEventToShow();
	});


	$('.btn-primary').on('click', function (event) {
		$element = event.target;
		populateEventsTable($element.id);
	});

	$eventsBoard.on('click', '.edit', function () {
		debugger
	});
});