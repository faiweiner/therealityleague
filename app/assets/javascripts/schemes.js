$(document).ready(function () {
	if ($('#manage-schemes').length > 0) {
		console.log('Schemes initialized');
		// ------------------------------------------------------ //
		// ================== GLOBAL VARIABLES ================== //
		// ------------------------------------------------------ //
		// setting variables
		$filterPanel = $('#filter_panel');
		$schemesBoard = $('#schemes_board');
		$schemesTable = $('#schemes_table');
		$schemeForm = $('#scheme_form');
		$schemeSubmitButton = $('.submit-btn');
		$schemeUpdateButton = $('.update-btn');
		$schemeClearButton = $('.cancel-btn');
		$schemeShows = $('#scheme_shows');
		$formAlert = $('#form_alert');

		// ------------------------------------------------------ //
		// ============== GLOBAL CLIENT FUNCTIONS =============== //
		// ------------------------------------------------------ //
		var hideActionButtons = function () {
			$eventsBoard.find('.save').hide();
			$eventsBoard.find('.destroy').hide();
		};

		var showElement = function (elementCollection, targetElementCollection) {
			for (var i = 0; i < targetElementCollection.length; i++) {
				var element = elementCollection.find(targetElementCollection[i]);
				element.show();
			}
		};

		var hideElement = function (elementCollection, targetElementCollection) {
			for (var i = 0; i < targetElementCollection.length; i++) {
				var element = elementCollection.find(targetElementCollection[i]);
				element.hide();
			}
		};

		// ------------------ Error Messges -------------------- //
		var formatErrorMessages = function (data) {
			$element = $('<ul/>');
			for (var i = 0; i < data.errors.length; i ++) {
				$bullet = $('<li/>');
				$bullet.text(data.errors[i]);
				$element.append($bullet);
			};
			return $element;
		};

		// ---------------------- Forms ------------------------ //
		var clearForm = function () {
			$formFields = $schemeForm.find('.form-group.field');
			$formFields[2].val('');
		};


		var baseFormConstruction = function (response) {
			$formGroups = $schemeForm.find('.form-group');
			$formGroups.children().attr('disabled', false);
			$formGroups.children().children().attr('disabled', false);
			$formGroups.find('#scheme_show_id').val(response.scheme.show_id);
			
			// Type
			var option = 'option[value="' + response.type + '"]';
			var typeField = $formGroups.find('#scheme_type_dropdown');
			var typeValue = $formGroups.find('#scheme_type_value');
			var selection = $formGroups.find('#scheme_type_dropdown').children(option)
			selection.attr('selected', 'selected');
			typeValue.empty().append(response.type);

			// Description
			var descriptionField = $formGroups.find('#scheme_description_input');
			var descriptionValue = $formGroups.find('#scheme_description_value');
			descriptionField.val(response.scheme.description);
			descriptionValue.empty().append(response.scheme.description);

			// Points
			var pointsField = $formGroups.find('#scheme_points_asgn_input');
			var pointsValue = $formGroups.find('#scheme_points_asgn_value');
			pointsField.val(response.scheme.points_asgn);
			pointsValue.empty().append(response.scheme.points_asgn);
		};

		var constructEditForm = function (response) {
			var shows = response.shows;
			var showsList = $schemeShows.find('#shows_list').children('input');
			
			// setting up Form
			baseFormConstruction(response);
			var showElementCollection = ['#scheme_type_dropdown', '#scheme_description_input', '#scheme_points_asgn_input', $schemeUpdateButton, $schemeShows];
			var hideElementCollection = ['#scheme_type_value', '#scheme_description_value', '#scheme_points_asgn_value', $schemeSubmitButton];
			showElement($formGroups, showElementCollection);
			hideElement($formGroups, hideElementCollection);
			
			// populating shows selected
			for (var i = 0; i < Object.keys(shows).length; i++) {
				var $checkbox = $(showsList).filter( function () {
					return ($(this).data("showId") == shows[i].id);
				});
				$checkbox.prop("checked", shows[i].include);
			};

		};		


		// ------------------------------------------------------ //
		// ============== GLOBAL BACKEND FUNCTIONS ============== //
		// ------------------------------------------------------ //

		var getSchemeData = function (url, actionFunction) {
			var responseData = {};
			$.ajax({
				url: url
			}).done(function (response) {
				responseData = response
				actionFunction(response);
				return responseData;
			});	
		};

		// ------------------ ACTION FUNCTIONS ------------------ //
		// Create
		var createScheme = function (data) {
			$.post('/schemes/', data)
			.done( function (response) {
				$showsListInput = $('#shows_list').children('input:checked')
				var showIdsList = [];
				
				for (var i = 0; i < $showsListInput.length; i++) {
					var showId = parseInt($showsListInput[i].dataset.showId);
					showIdsList.push(showId);
				};
				
				var dataPackage = {
					schemeId: response.scheme_id,
					showIdsList: showIdsList
				}

				$formAlert.empty();
				$formAlert.attr('class', '');
				$formAlert.addClass('alert ' + response.color);
				$formAlert.text(response.notice);
				$schemesBoard.empty().html(response.schemeList);

				assignScheme(dataPackage);
			}).error( function (response) {
				$formAlert.empty();
				$formAlert.attr('class', '');
				$formAlert.addClass('alert ' + response.responseJSON.color);
				$errorMessageStrong = $('<strong/>');
				$errorMessageStrong.text(response.responseJSON.notice);
				$formAlert.append($errorMessageStrong);
				$element = formatErrorMessages(response.responseJSON);
				$formAlert.append($element);
			}); 
		};

		// Update
		var updateScheme = function (schemeId, data) {
			var url = '/schemes/' + schemeId;
			$.ajax({
				url: url,
				type: 'PATCH',
				data: data,
				success: function (response) {
					$formAlert.empty();
					$formAlert.attr('class', '');
					$formAlert.addClass('alert ' + response.color);
					$formAlert.text(response.notice);
					$eventsBoard.reload(true);
				}, 
				error: function (data) {
					$formAlert.empty();
					$formAlert.attr('class', '');
					$formAlert.addClass('alert ' + data.responseJSON.color);
					$formAlert.text(data.responseJSON.notice);					
				}
				
			});
		};

		// Assign
		var assignScheme = function (dataPackage) {
			var schemeId = dataPackage.schemeId
			var url = '/schemes/' + schemeId + '/assign';
			$.post(url, dataPackage);
		};

		// ------------------------------------------------------ //
		// ================ FRONTEND FUNCTIONS ================== //
		// ------------------------------------------------------ //

		//timeout for alerts
		$(function() {
			// setTimeout() function will be fired after page is loaded
			// it will wait for 5 sec. and then will fire
			// $("#successMessage").hide() function
			setTimeout(function() {
				$("#scheme_action_alert").hide('blind', {}, 100)
			}, 2000);
			setTimeout(function() {
				$formAlert.hide('blind', {}, 100)
			}, 2000);
		});

		// ------------------ EVENT LISTENERS -------------------- //
		// Type Dropdown on Form
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

		var mineSchemeData = function (dataSource) {
			$source = dataSource;
			$formFields = $(event.target).parents('form').children('.form-group');

		};
		// Action for Form
		$schemeForm.on('click', '.actions', function (event) {
			debugger
			$formAlert.empty();
			$formAlert.attr('class', '');	
			$actionButton = $(event.target);
			var schemeId = $actionButton.data().id;
			var formAction = {
				method: $actionButton.attr('method'),
				action: $actionButton.attr('action')
			}
			// set up parameters
			var id = event.target.dataset.id;
			var schemeTypeDropdown = $formFields.find('#scheme_type_dropdown');
			var schemeTypeText = $formFields.find('select').filter('#scheme_type_dropdown').val();
			var description = $formFields.find('#scheme_description_input').val();
			var pointsAsgn = $formFields.find('#scheme_points_asgn_input').val();
			// setting up schemeData
			var schemeData = {
				id: id,
				description: description,
				points_asgn: pointsAsgn		
			};

			// setting up parameters
			var data = {
				scheme: schemeData,
				type_text: schemeTypeText
			}	
			switch ($actionButton.attr('action')) {
				case 'create':
					createScheme(data);
					break;
				case 'update':
					updateScheme(schemeId, data);
					break;
				case 'cancel':
					console.log('clear');
					break;	
			}
		}).on('click', '.clear', function (event) {
		}).on('ajax:success', function (event, data, status, xhr) {
			$formAlert.empty();
			console.log('hi');
			$formAlert.attr('class', '');
			$formAlert.addClass('alert ' + data.color);
			$formAlert.text(data.notice);
		}).on('ajax:error', function (event, data, status, xhr) {
			$formAlert.empty();
			$formAlert.attr('class', '');
			$formAlert.addClass('alert ' + data.responseJSON.color);
			$errorMessageStrong = $('<strong/>');
			$errorMessageStrong.text(data.responseJSON.notice);
			$formAlert.append($errorMessageStrong);
			$element = formatErrorMessages(data.responseJSON);
			$formAlert.append($element);
		});

		// Shows Filter on Display Board
		$filterPanel.on('change', 'select', function (event) {
			var element = event.target;
			var showId = $(element).val();
			$.ajax({
				url: '/schemes/fetch_schemes',
				data: {show_id: showId},
				success: function (response) {
					$schemesTable.load();
				}
			});
		// 	var showId = element.dataset.showId;
		// 	$('#scheme_show_id').val(showId);
		// 	if (showId == null) {
		// 		$('.form-group').children().attr('disabled', 'disabled');
		// 	} else {
		// 		$('.form-group').children().attr('disabled', false);
		// 	}
		// 	$showsPanel.children('.btn').removeClass('btn-primary');
		// 	$(element).addClass('btn-primary');
		});

		// Action buttons on Display Board
		$schemesBoard.on('click', '.action', function (event) {
			$formAlert.empty();
			$formAlert.attr('class', '');	
			var id = event.target.dataset.id;
			var classesList = event.target.classList;
			var action, responseData;
			var url = 'schemes/' + id;
			for (var i = 0; i < classesList.length; i ++) {
				if (classesList[i] == 'edit') {
					action = 'edit';
					url += '/edit';
					$schemeUpdateButton.attr('data-id', id);
				};
			};
			switch (action) {
				case 'edit':
					responseData = getSchemeData(url, constructEditForm);
					break;
			};

		});
	}
});