$(document).ready(function () {
	console.log('Contestants initialized');

	$.fn.editable.defaults.mode = 'popup';
	$('#username').editable();
	// ========= universal click listener ========= //
	$('.edit').on('click', function (event) {
		$element = event.target
		$element.contentEditable('/contestants/update/', {

		});

		console.log($element);
	});
});