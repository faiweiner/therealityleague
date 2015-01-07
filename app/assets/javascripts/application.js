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

	var clearField = function (fieldId) {
		var targetfieldId = '#' + fieldId;
		var targetField = $(targetfieldId);
		targetField.val('');
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
					messagecomment:	formData[4].value
				}},
				dataType: 'JSON',
				success: function (data, textStatus, jqXHR) {
				},
				failure: function (data, jqXHR, textStatus) {
				}
			}).done(function (data){
				$responseBox = $('#post-response-box')
				$responseBox.addClass('alert-success');
				var successMessage = data.success;
				$responseBox.text(data.success);

				clearField('message_user_id');
				clearField('message_messagetype');
				clearField('message_messagecomment');
								
			});


			e.preventDefault(); //STOP default action
		});
	};
});