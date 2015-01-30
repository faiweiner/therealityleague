$(document).ready(function () {
	if ($('#manage-schemes').length > 0) {
		console.log('Schemes initialized');
		// setting variables
		$showsPanel = $('#shows_panel');
		$schemesBoard = $('#schemes_board');
		$schemesTable = $('#schemes_table');
		$newSchemeForm = $('#new_scheme');
		$schemeUpdateButton = $('<div/>');
		$schemeClearButton = $('<div/>');
		// ================== GLOBAL FUNCTIONS ================== //

		// ----- BEGIN server-side ----- //
		// sends data to server for addition to events
		var addSchemeToShow = function () {
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

		var formatErrorMessages = function (data) {
			$element = $('<ul/>');
			for (var i = 0; i < data.errors.length; i ++) {
				$bullet = $('<li/>');
				$bullet.text(data.errors[i]);
				$element.append($bullet);
			};
			return $element;
		};

		$('#scheme_form_type').on('change', function (event) {
			var val = event.target.value;
			$typeText = $('#scheme_type_text');
			if (val == 'Add new type') {
				$typeText.removeClass('hidden');
				$typeText.focus();
			} else {
				$typeText.addClass('hidden');
			}; 
		});

		$showsPanel.on('click', '.btn', function (event) {
			var element = event.target;
			var showId = element.dataset.showId;
			$('#scheme_show_id').val(showId);
			if (showId == null) {
				$('.form-group').children().attr('disabled', 'disabled');
			} else {
				$('.form-group').children().attr('disabled', false);
			}
			$showsPanel.children('.btn').removeClass('btn-primary');
			$(element).addClass('btn-primary');
		});

		$schemesBoard.on('click', '.edit', function (event) {
			var id = event.target.dataset.id;
			var url = 'schemes/' + id + '/edit';
			$.ajax({
				url: url
			}).done(function (response) {
				var updateURL = '/schemes/'+ response.scheme.id;
				$newSchemeForm.children('.form-group.field').children('#scheme_show_id').val(response.scheme.show_id);
				// Type
				var option = 'option[value="' + response.type + '"]';
				var typeField = $newSchemeForm.children('.form-group.field').children('#scheme_type_dropdown');
				var selection = $newSchemeForm.children('.form-group.field').children('#scheme_type_dropdown').children(option)
				selection.attr('selected', 'selected');
				// Description
				var descriptionField = $newSchemeForm.children('.form-group.field').children('#new_scheme_description');
				descriptionField.val(response.scheme.description);
				// Points
				var pointsField = $newSchemeForm.children('.form-group.field').children('#new_scheme_points');
				pointsField.val(response.scheme.points_asgn);

				// Enabling form
				$('#new_scheme_submit').hide();
				$schemeUpdateButton.addClass('btn btn-md btn-default update');
				$schemeClearButton.addClass('btn btn-md btn-default clear');
				$schemeUpdateButton.attr('data-id', id);
				$schemeUpdateButton.text('Update scheme');
				$schemeClearButton.text('Cancel');
				$('.actions').append($schemeUpdateButton).append(" ");
				$('.actions').append($schemeClearButton).append(" ");
				$('#new_scheme_update').attr('href', updateURL);
				$('.form-group').children().attr('disabled', false);
			});
		});

		$newSchemeForm.on('click', '.update', function (event) {
			$formFields = $(event.target).parent().siblings('.form-group.field');
			var id = event.target.dataset.id;
			var showId = $formFields.find('#scheme_show_id').val();
			var schemeTypeDropdown = $formFields.find('#scheme_type_dropdown').val();
			var schemeTypeText = $formFields.find('#scheme_type_text').val();
			var description = $formFields.find('#new_scheme_description').val();
			var pointsAsgn = $formFields.find('#new_scheme_points').val();
			
			var url = '/schemes/' + id;
			var schemeData = {
				id: id,
				type_text: schemeTypeText,
				type_select: schemeTypeDropdown,
				show_id: showId,
				description: description,
				points_asgn: pointsAsgn
			};
			$.ajax({
				url: url,
				dataType: 'JSON',
				type: 'PATCH',
				data: schemeData,
				success: function (data) {
				}
			});
		}).on('ajax:success', function (event, data, status, xhr) {
			console.log(status);
		}).on('ajax:error', function (event, data, status, xhr) {
			$errorExplanation = $('#error_explanation');
			$errorExplanation.addClass('alert ' + data.responseJSON.color);
			$errorMessageStrong = $('<strong/>');
			$errorMessageStrong.text(data.responseJSON.notice);
			$errorExplanation.append($errorMessageStrong);
			$newSchemeForm.append(data.responseText);
			$element = formatErrorMessages(data.responseJSON);
			$errorExplanation.append($element);
		});
	};
});