$(document).ready(function () {
	console.log('Contestants initialized');

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
	$.extend($.fn.editable.defaults, defaults);

	$('#contestants span[data-name="name"]').editable({
		title: 'Enter name',
		tpl: "<input type='text' style='width: 100px'>"
	});

	$('#contestants span[data-name="age"]').editable({
		tpl: "<input style='width: 55px'>"
	});

	$('#contestants span[data-name="occupation"]').editable({
		title: 'Enter occupation',
		tpl: "<input style='width: 100px'>",
		type: 'textarea'
	});

$('#contestants span[data-name="description"]').editable({
		title: 'Enter description',
		type: 'textarea'
	});

	$('#contestants').on('click', '.edit', function(){
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
			$btn.closest('tr').find('.editable').editable('hide');
			$btn.hide().siblings('.edit').show();
	});

	// //ajax emulation
	// $.mockjax({
	// 		url: '/post',
	// 		responseTime: 200,
	// 		response: function(settings) {
	// 			console.log(settings.data);   
	// 	 }
	// }); 

});
