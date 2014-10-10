$(document).ready(function () {

	if ($('#manage-schemes').length > 0) {
		console.log('Schemes initialized');

		// setting variables
		$showsPanel = $('#shows-panel');
		$newSchemeBoard = $('#newSchemeBoard');
		$currentSchemeBoard = $('#currentSchemeBoard');

		$('.btn-primary').on('click', function (event) {
			var $showId = event.target.id;
			$.ajax({
				url: '/api/schemes',
				data: 'show_list='+ $showId,
				dataType: 'json',
				type: 'get',
				success: function (response) {
					var partial = response.schemesList;
					$currentSchemeBoard.data(partial);
				}	// end success function
			});
		});
		$newEventForm = $('#new-event');
		$newEventSubmitButton = $('#new-event-submit');
		$eventsBoard = $('#events-board');
		$eventsDisplayBox = $('#events-display-box');
	
	// ================== IN-LINE EDITING ================== //
		$.extend($.fn.editable.defaults, defaults);

		var makeElementsReloadable = function (eventTypeValue) {

			$eventsBoard.find('span[data-name="type"]').editable({
				type: 'select',
				tpl: '<select style="width: 100px">',
				display: 'value',
				value: eventTypeValue,
				source: [
					{'value': 'Survival', 'text': 'Survival'},
					{'value': 'Game', 'text': 'Game'},
					{'value': 'Extracurricular', 'text': 'Extracurricular'}
				]
			});

			$eventsBoard.find('span[data-name="event"]').editable({
				title: 'Enter event',
				tpl: "<input type='text' style='width: 200px'>"
			});

			$eventsBoard.find('span[data-name="points_asgn"]').editable({
				title: 'Enter points',
				tpl: "<input style='width: 50px'>",
				validate: function (value) {
					if ($.trim(value) == '') {
						return 'This field is required';
					}
				}	
			});
		};

		$('#event-display-box').on('click', '.save', function() {
			var $btn = $(this);
			var eventId = jQuery(this).closest('tr').find('span')[0].dataset.pk;
			$.ajax({
				url: '/schemes/' + eventId,
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
				url: '/schemes/',
				type: 'POST',
				success: function () {
					$eventsBoard.reload(true);
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


		$eventsBoard.on('click', '.edit', function () {
			// Get value of event type to be populated in X-editable
			var eventTypeValue = $(this).closest('tr').find('span[data-name="type"]').text();
			makeElementsReloadable(eventTypeValue);	
			$eventsBoard.find('.editable-open').editable('hide');
			$(this).hide().siblings('.btn-primary').show();
			$(this).siblings('.btn-danger').show();
			$(this).closest('tr').find('.editable').editable('show');
		});



	};
});