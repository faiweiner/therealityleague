$(document).ready(function () {
	console.log('Contestants initialized');

	$.fn.editable.defaults.mode = 'popup';

	var make_editable = function (element_id) {
		var element = '#' + element_id;
		console.log(element);
		$(element).editable({});
		console.log('I got here');
	};

	// ========= universal click listener to get ID ========= //

	$('.editable').on('click', function (event) {
		// records which element is being clicked
		var element_id = event.target.id;
		console.log(element_id);
		make_editable(element_id);
	});


});
