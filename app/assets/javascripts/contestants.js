$(document).ready(function () {

	if ($('#contestants').length > 0) {
		console.log('Contestants JS initialized');

		// ================== IN-LINE EDITING ================== //

		var toggleActionButtons = function () {
			// $('#contestants').find('.save').hide();
			// $('#contestants').find('.edit').show();
			// $(this).hide().siblings('.save').show();
			// $(this).siblings('.cancel').show();
		};

		$.extend($.fn.editable.defaults, defaults);

		$('#contestants').find('.save').hide();
		$('#contestants').find('.cancel').hide();		

		$('#contestants span[data-name="name"]').editable({
			title: 'Enter name',
			tpl: "<input type='text' id='contestant_name' name='contestant[name]' style='width: 125px'>"
		});

		$('#contestants span[data-name="age"]').editable({
			tpl: "<input style='width: 55px' id='contestant_age' name='contestant[age]'>"
		});

		$('#contestants span[data-name="gender"]').editable({
			tpl: "<input style='width: 55px' id='contestant_gender' name='contestant[gender]'>"
		});

		$('#contestants span[data-name="occupation"]').editable({
			title: 'Enter occupation',
			tpl: "<input style='width: 185px' id='contestant_occupation' name='contestant[occupation]'>",
		});

		$('#contestants').on('click', '.edit', function () {
			$('#contestants').find('.editable-open').editable('hide');
			
			$(this).closest('tr').find('.editable').editable('show');
	
			$('#contestants').on('click', '.cancel', function() {
				var $btn = $(this);
				$btn.closest('tr').find('.editable').editable('hide');
				toggleActionButtons();
				// $btn.siblings('.cancel').hide();
				// $btn.hide().siblings('.edit').show();
			});
	
			$('#contestants').on('click', '.save', function() {
				var $btn = $(this);
				
				 // Currently no elegant way to get actual values from shown inputs.
				 // It's possible to collect it manually, submit and then use `setValue` method to update data in table row. But it's overload..
				 // Need investigation.
				
				var contestantId = jQuery(this).closest('tr').find('span')[0].dataset.pk

				var seasonId = $('#season_id').text();
				var contestantName = $('#contestant_name').val();
				var contestantAge = $('#contestant_age').val();
				var contestantOccupation = $('#contestant_occupation').val();
				var contestantDescription = $('#contestant_description').val();
				console.log(contestantName);
				console.log(seasonId);
				console.log(contestantAge);
				console.log(contestantOccupation);
				console.log(contestantDescription);

				var postURL = '/contestants/' + contestantId;

				$.ajax({
					url: postURL,
					type: patch,
				})

				$btn.closest('tr').find('.editable').editable('hide');
				$btn.siblings('.cancel').hide();
				$btn.hide().siblings('.edit').show();

			});
		});

		$('.input').keypress(function (e) {
			if (e.which == 13) {
				$('form#login').submit();
			}
		});


		
	};


});
