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
			title: 'Enter name'
	});

	$('#contestants span[data-name="age"]').editable({
			title: 'Enter age',
			type: 'select',
			source: [
					{value: 1, text: '< 10'},
					{value: 2, text: '10 - 20'},
					{value: 3, text: '20 - 30'},
					{value: 4, text: '> 30'}
			]
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

	//ajax emulation
	$.mockjax({
			url: '/post',
			responseTime: 200,
			response: function(settings) {
				console.log(settings.data);   
		 }
	}); 

});
