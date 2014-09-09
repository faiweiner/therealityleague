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
		tpl: "<input type='text' id='contestant_name' name='contestant[name]' style='width: 125px'>"
	});

	$('#contestants span[data-name="age"]').editable({
		tpl: "<input style='width: 55px' id='contestant_age' name='contestant[age]'>"
	});

	$('#contestants span[data-name="occupation"]').editable({
		title: 'Enter occupation',
		tpl: "<input style='width: 185px' id='contestant_occupation' name='contestant[occupation]'>",
	});

	$('#contestants span[data-name="description"]').editable({
		title: 'Enter description',
		type: 'textarea',
		escape: 'true',
		tpl: "<textarea id='contestant_description' name='contestant[description]'>",
		row: 2
	});

	$('#contestants').on('click', '.edit', function () {
		$('#contestants').find('.editable-open').editable('hide');
		$('#contestants').find('.btn-primary').hide();
		$('#contestants').find('.edit').show();
		$(this).hide().siblings('.btn-primary').show();
		$(this).closest('tr').find('.editable').editable('show');
	});

	$('.input').keypress(function (e) {
		if (e.which == 13) {
			$('form#login').submit();
		}
	});

	$('#contestants').on('click', '.btn-primary', function() {
		var $btn = $(this);
		/*
		 Currently no elegant way to get actual values from shown inputs.
		 It's possible to collect it manually, submit and then use `setValue` method to update data in table row. But it's overload..
		 Need investigation.
		*/
		var contestantId = jQuery(this).closest('tr').find('span')[0].dataset.pk
		console.log(contestantId);
		$.ajax({
			url: '/contestants/' + contestantId,
			type: 'POST',
			data: {
				name:  'name',  //name of field (column in db)
				pk:    contestantId,            //primary key (record id)
				value: 'superuser!' //new value
			},
			success: function(response, newValue) {
				if(response.status == 'error') return response.msg; //msg will be shown in editable form
			}
		});
		$btn.closest('tr').find('.editable').editable('hide');
		$btn.hide().siblings('.edit').show();
	});

});
