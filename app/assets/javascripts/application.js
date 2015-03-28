// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require underscore
//= require bootstrap.min
//= require_tree .



var defaults = {
	mode: 'inline', 
	toggle: 'manual',
	showbuttons: false,
	onblur: 'ignore',
	inputclass: 'input-small',
	savenochange: true,
	success: function() {
		return false;
	}    
};

console.log('X-Editable defaults initialized');

$(document).ready(function () {

	var clearField = function (targetField) {
		targetField.val('');
	};

	var	hideFormGroup = function (formGroupId) {
		$formGroup = $(formGroupId);
		$formGroup.hide();
	};
	var showFormGroup = function (formGroupId) {
		$formGroup = $(formGroupId);
		$formGroup.show();
	};

	var addAlertClass = function (formGroupId, status) {
		if (status == "success") {
			$targetElement = $(formGroupId)
		} else if (status == "error") {

		}
	};
	var clearFormAlert = function (jQUERYelement) {	
		jQUERYelement.empty()
		jQUERYelement.attr('class', '');	
	};

	if ($('#feedbackBox')) {
		$('#new_message').submit(function (e) {
			var formData = $(this).serializeArray();
			var responseMessage;

			$.ajax({
				url : '/messages',
				type: 'POST',
				data: {message: {
					user_id: 				formData[2].value,
					messagetype:		formData[3].value,
					messagecomment:	formData[4].value,
					pageurl:				window.location.pathname
				}},
				dataType: 'JSON',
				success: function (data, textStatus, jqXHR) {
				},
				failure: function (data, jqXHR, textStatus) {
				}
			}).done(function (data){
				$responseBox = $('#post-response-box');
				$responseBox.show();
				$responseBox.addClass('alert-success');
				if (data.success) {
					addAlertClass('#post-response-box', 'success');
				} else if (data.error) {
					addAlertClass('#post-response-box', 'error');
				}
				var successMessage = data.success;
				$responseBox.text(data.success);

				clearField($('#message_messagecomment'));

				// $responseBox.text('').delay(5000);
				// $responseBox.hide().delay(1000);
			});


			e.preventDefault(); //STOP default action
		});

	

		$('.close').on('click', function () {
			$('#post-response-box').text('');
			$('#post-response-box').hide();
		});

		$('#form-cancel-button').on('click', function () {
			$('#post-response-box').text('');
			$('#post-response-box').hide();
		});
	};

	// Facebook Signup Click Listener
	if ($('#fb-signup')) {
		$('#fb-signup').on('click', '#fb-signup-button', function () {
			var _self = this;
				FB.login(function (response) {
					// check current FB linkage status
					console.log(response);
					var userID = null;
					if (response.authResponse !== undefined) {
						userID = response.authResponse.userID
					};
					var action = _self.dataset.action;
						statusChangeCallback(response, userID, action);
					}, {scope: 'public_profile, email, user_friends'}
			);
		});
	};

	// Facebook Login Click Listener
	if ($('#fb-login')) {
		$('#fb-login').on('click', '#fb-login-button', function () {
			var _self = this;
			FB.login(function (response) {
				// check current FB linkage status
				console.log(response);
				var userID = null;
				if (response.authResponse !== undefined) {
				        userID = response.authResponse.userID
				};
				console.log(userID);
				var action = _self.dataset.action;
				statusChangeCallback(response, userID, action);
			}, {scope: 'public_profile, email, user_friends'}
			);
		});
	};	

		// Facebook Link Click Listener
	if ($('#fb-link')) {
		$('#fb-link').on('click', '#fb-link-button', function () {
			var _self = this;

			// check current FB linkage status
			FB.login(function (response) {
				var userId = _self.dataset.userId;
				var action = _self.dataset.action;
				// call statusChangeCallback to link user
				statusChangeCallback(response, userId, action);
				}, {scope: 'public_profile, email, user_friends'}
			);
		});
	};		
});