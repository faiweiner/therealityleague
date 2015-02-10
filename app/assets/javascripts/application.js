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
//= require bootstrap3-editable/bootstrap-editable
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

	var updateFbButtonLabel = function (message) {
		$('#fb-login-button').text(message);
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

	if ($('#fb-login')) {
		$('#fb-login').on('click', '#fb-login-button', function () {
			// check current FB linkage status
			var currentStatus = status;
			// indicates if user is signing up, or linking, or etc.
			var action = this.dataset.action;
			// set variable for below switch
			var scenario = '';

			if (currentStatus === null || action === null)  {
				// This scenario is when Facebook status cound not be established
				// and no value is assigned to "action" or variable does not exist
				scenario = 'fbError';
			} else if (currentStatus === 'not_authorized' && action === 'signup-fb') {
				// User is logged into Facebook but not to the app
				// First time signing up via Facebook
				scenario = 'B';
			} else if (currentStatus === 'not_authorized' && action === 'signin-fb') {
				// User is logged into Facebook but not to the app
				// Current user signing in with Facebook
				scenario = 'C';
			} else if (currentStatus === 'not_authorized' && action === 'link-fb') {
				// User is logged into Facebook but not to the app
				// Current user want to link account to FB for future use
				scenario = 'D';
			} else if (currentStatus === 'unknown') {
				scenario = 'noFbConnection'
			};
			
			console.log(scenario);

			switch (scenario) {
				case 'fbError':
					updateFbButtonLabel('Try again');
					break;
				case 'B':
					signupFbUser();
					updateFbButtonLabel('Sign up with Facebook');
					break;
				case 'C':
					updateFbButtonLabel('dooze');
					break;
				case 'D':
					updateFbButtonLabel('coooozzzee');
					break;
				case 'noFbConnection':
					updateFbButtonLabel('COOOOO');
					break;
			};
		});
	};	
});