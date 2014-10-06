$(document).ready(function () {
	if ($('#season-display').length > 0) {
		console.log('season JS file initiated');
		$('.fading').hover(
				function () {
					var $element = $(this);
					$caption = $element.find('.caption');
					$caption.find('.name').hide(250);
					$statusText = $element.find('.status').text();
					$element.find('.status').show(250);
				},
				function () {
					var $element = $(this);
					$statusText = $element.find('.status').text();
					$element.find('.status').hide(250);
					$caption = $element.find('.caption');
					$caption.find('.name').show(250);
				}
		)
	}
});