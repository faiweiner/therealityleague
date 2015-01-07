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
	if ($('#feedbackBox')) {
		$('#new_message').submit(function (e) {
			var formData = $(this).serializeArray();
			$.ajax({
				url : '/messages',
				type: 'POST',
				data: {message: {
					user_id: 				formData[2].value,
					messagetype:		formData[3].value,
					messagecomment:	formData[4].value
				}},
				success: function(data, textStatus, jqXHR) {
					console.log(data.responseJSON);
				},
				error:function (data, jqXHR, textStatus) {
					var message = data.responseJSON.error;
					console.log(jqXHR);
					console.log(textStatus);
				}
			});

			e.preventDefault(); //STOP default action
		 
			$("#ajaxform").submit(); //Submit  the FORM
		});
	};
});