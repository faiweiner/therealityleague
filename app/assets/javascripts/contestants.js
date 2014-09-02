$(document).ready(function () {

	if ($('#contestants').length == 0) {
		return;
	};

	console.log('Contestants initialized');

	// ================== IN-LINE EDITING ================== //

	$.extend($.fn.editable.defaults, defaults);

	$('#contestants').find('.btn-primary').hide();

	$('#contestants span[data-name="name"]').editable({
		title: 'Enter name',
		tpl: "<input type='text' style='width: 125px'>"
	});

	$('#contestants span[data-name="age"]').editable({
		tpl: "<input style='width: 55px'>"
	});

	$('#contestants span[data-name="occupation"]').editable({
		title: 'Enter occupation',
		tpl: "<input style='width: 185px'>",
	});

	$('#contestants span[data-name="description"]').editable({
		title: 'Enter description',
		type: 'textarea',
		rows: 2,
	});

	$('#contestants').on('click', '.edit', function (){
		$('#contestants').find('.editable-open').editable('hide');
		$('#contestants').find('.btn-primary').hide();
		$('#contestants').find('.edit').show();
		$(this).hide().siblings('.btn-primary').show();
		$(this).closest('tr').find('.editable').editable('show');
	});

	$('#contestants').on('click', '.btn-primary', function() {
		var $btn = $(this);
		/*
		 Currently no elegant way to get actual values from shown inputs.
		 It's possible to collect it manually, submit and then use `setValue` method to update data in table row. But it's overload..
		 Need investigation.
		*/
		var contestantId = jQuery(this).closest('tr').find('span')[0].dataset.pk
		$.ajax({
			url: '/contestants/' + contestantId,
			type: 'POST',
			responseTime: 200,
			response: function(settings) {
				console.log(settings.data);   
		 	}
			// success: function (msg) {
			// 	var partial = msg;
			// 	$rosterBoard.html(partial);
			// }
		});

		$btn.closest('tr').find('.editable').editable('hide');
		$btn.hide().siblings('.edit').show();
	});

});
