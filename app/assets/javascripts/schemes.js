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
			$formFields = $schemeForm.find('.form-group');
			$formFields.find('#scheme_type_dropdown').val('');
			$formFields.find('#scheme_description_input').val('');
			$formFields.find('#scheme_points_asgn_input').val('');
			var showsList = $formFields.find('#shows_list').children('input');
			for (var i = 0; i < showsList.length; i++) {
				var $checkbox = $(showsList[i]);
				$checkbox.prop("checked", false);
			};
			$formFields.find('.submit-btn').toggle();
			$formFields.find('.update-btn').toggle();
		};

		var clearFormAlert = function () {
			$formAlert.empty();
			$formAlert.attr('class', '');	
		};

		// Populate form with response data
		var baseFormConstruction = function (response) {
			$formGroups = $schemeForm.find('.form-group');
			$formGroups.children().attr('disabled', false);
			$formGroups.children().children().attr('disabled', false);
			
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

		var mineFormData = function (dataSource) {
			$source = $(dataSource);
			$formFields = $(event.target).parents('form').children('.form-group');
			var schemeId = $source.data().id;
			var formAction = {
				method: $source.attr('method'),
				action: $source.attr('action')
			}

			// set up parameters
			var schemeId = $source.data().id;
			var schemeTypeDropdown = $formFields.find('#scheme_type_dropdown');
			var schemeTypeText = $formFields.find('select').filter('#scheme_type_dropdown').val();
			var description = $formFields.find('#scheme_description_input').val();
			var pointsAsgn = $formFields.find('#scheme_points_asgn_input').val();
			var schemeShows = $formFields.find('#shows_list').children('input:checked');
			var showIdsList = [];
			
			for (var i = 0; i < schemeShows.length; i++) {
				$schemeShow = $(schemeShows[i]);
				var showId = parseInt($schemeShow.data().showId);
				showIdsList.push(showId);
			};
			// setting up schemeData
			var schemeData = {
				id: schemeId,
				description: description,
				points_asgn: pointsAsgn		
			};

			// setting up parameters
			var data = {
				scheme: schemeData,
				type_text: schemeTypeText,
				showIdsList: showIdsList
			}	
			
			return data
		};
		// ------------------------------------------------------ //
		// ============== GLOBAL BACKEND FUNCTIONS ============== //
		// ------------------------------------------------------ //

		var getSchemeData = function (url, actionFunction) {
			var responseData;
			$.ajax({
				url: url
			}).done(function (response) {
				actionFunction(response);
				responseData = response
				console.log(response);
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

				clearFormAlert();
				$formAlert.addClass('alert ' + response.color);
				$formAlert.text(response.notice);
				$schemesBoard.empty().html(response.schemeList);

				// assignScheme(dataPackage);
			}).error( function (response) {
				clearFormAlert();
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
			assignScheme(data);
			$.ajax({
				url: url,
				type: 'PATCH',
				data: data,
				success: function (response) {
					clearForm();
					clearFormAlert();
					$formAlert.addClass('alert ' + response.color);
					$formAlert.text(response.notice);
				}, 
				error: function (data) {
					clearFormAlert();
					$formAlert.addClass('alert ' + data.responseJSON.color);
					$formAlert.text(data.responseJSON.notice);					
				}
			}).done( function (response) {
				console.log(response);
			});
		};

		// Assign
		var assignScheme = function (dataPackage) {
			var schemeId = dataPackage.scheme.id;
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
				$('#scheme_action_alert').hide('blind', {}, 100)
			}, 2000);
			setTimeout(function() {
				$('#form_alert').hide('blind', {}, 100)
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

		// Action for Form
		$schemeForm.on('click', '.actions', function (event) {
			clearFormAlert();
			var action = $(event.target).attr('action');
			switch (action) {
				case 'create':
					var data = mineFormData(event.target);
					createScheme(data);
					break;
				case 'update':
					var dataPackage = mineFormData(event.target);
					var schemeId = dataPackage.scheme.id;
					updateScheme(schemeId, dataPackage);
					break;
				case 'cancel':
					clearForm();
					break;	
			}
		}).on('click', '.clear', function (event) {
		}).on('ajax:success', function (event, data, status, xhr) {
			clearFormAlert();
			$formAlert.addClass('alert ' + data.color);
			$formAlert.text(data.notice);
		}).on('ajax:error', function (event, data, status, xhr) {
			clearFormAlert();
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
			$filterFields = $(element).closest('#filters').children()
			$showFilter = $filterFields.find('#show');
			$schemeTypeFilter = $filterFields.find('#scheme_type')
			var showId = $showFilter.val();
			var schemeType = $schemeTypeFilter.val()
			$.ajax({
				url: '/schemes/fetch_schemes',
				data: {
					show_id: showId,
					scheme_type: schemeType
				},
				success: function (response) {
					$schemesTable.load();
				}
			});
		});

		// Action buttons on Display Board
		$schemesBoard.on('click', '.action', function (event) {
			clearFormAlert();
			var id = event.target.dataset.id;
			var classesList = event.target.classList;
			var action, responseData;
			var url = 'schemes/' + id;

			// Determine action and URL
			for (var i = 0; i < classesList.length; i ++) {
				if (classesList[i] == 'edit') {
					action = 'edit';
					url += '/edit';
					$schemeUpdateButton.attr('data-id', id);
				};
			};

			// Switch case for action
			switch (action) {
				case 'edit':
					responseData = getSchemeData(url, constructEditForm);
					break;
			};

		});
	}
});