$(document).ready(function () {
	console.log('Contestants initialized');

	// ========= universal click listener ========= //
	$('.edit').on('click', function (event) {
		$element = event.target
		$element.contentEditable = "true";

		console.log($element);
	});
});