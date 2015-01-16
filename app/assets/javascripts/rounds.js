// var oReq = new XMLHttpRequest;

// var getXMLHttpRequest = function () {	
// 	if (window.XMLHttpRequest) {
// 		return new window.XMLHttpRequest;
// 	} else {
// 		try {
// 			return new ActiveXObject("MSXML2.XMLHTTP.3.0");
// 		}
// 		catch(ex) {
// 			return null;
// 		}
// 	}
// }

// var handler = function () {
// 	if (oReq.readyState == 4 /* complete */) {
// 		if (oReq.status == 200) {
// 			console.log(oReq.responseText);
// 		}
// 	}
// };

// var oReq = getXMLHttpRequest();

// if (oReq != null) {
// 	oReq.open("GET", document.url, true);
// 	oReq.onreadystatechange = handler;
// 	oReq.send();
// } else {
// 	window.console.log("AJAX (XMLHTTP) not supported.");
// }

$(document).ready(function () {
	if ($('#bracketBoard').length > 0) {
		console.log('Round Selection Board initialized');
		$bracketBoard = $('#bracketBoard');               // overaching DIV covering the below
		$roundEditBoard = $('#roundEdit');
		$episodeBoard = $('#episodeBoard');
		$roundNavBoard = $('#round-navigation')
		// Server data
		var roundsCount = $('#episodeBoard').data().roundsCount;
		var roundsIds = $('#episodeBoard').data().roundsIds;

		// Client-side data
		var activeRoundId = $('li.btn-primary.selected').data().roundId;
		
		// Button changer
		$saveButton = $('#saveButton');

		$selectedRoundButton = $('.btn.btn-block.btn-sm.btn-primary.selected')
		var selectedRoundId = $selectedRoundButton.data().roundId;

		// ========== Begin server-side ========== //
		
		// --- adding/removing contestants from round by round ID --- //
		var addContestantToRound = function (contestantId, roundId) {
			$.ajax({
				url: '/rounds/' + roundId + '/add/' + contestantId,
				type: 'POST',
				success: function (msg) {
				}
			}).done(function (msg) {      
				$roundEditBoard.html(msg);
			});
		};

		var bulkAddContestantsToRound = function (roundId) {
			$.ajax({
				url: '/rounds/' + roundId + '/bulk',
				type: 'POST',
				success: function (msg) {
				}
			}).done(function (msg) {   
				$roundEditBoard.html(msg);
			});
		};

		var removeContestantFromRound = function (contestantId, roundId) {
			$.ajax({
				url:  '/rounds/' +  roundId + '/remove/' + contestantId,
				type: 'POST',
				success: function (msg) {
				},
				error: function (msg) {}
			}).done(function (msg) {
				$roundEditBoard.html(msg);
			});
		};

		var refreshRoundEditBoard = function (roundId, leagueId) {
			var msg;
			$.ajax({
				url: '/rounds/' + roundId,
				type: 'GET',
				success: function (msg) {
				}
			}).done(function (msg) {    
				$roundEditBoard.html(msg);
				toggleEpisodeButtonById(roundId);	
			});
		};			

		// ========== END server-side ========== //

		// ========== BEGIN client-side ========== //

		// --- Retrieving round ID --- //8
		var detectActiveRoundByElement = function (element) {
			var detectedActiveRoundId = element.dataset.roundId;
			return detectedActiveRoundId;
		};

		var detectActiveRoundByEnvironment = function () {
			var activeRoundId = $('li.btn-primary.selected').data().roundId;
			return activeRoundId;
		};

		var selectNavCheckElement = function (activeRoundId) {
			var activeNavElement = $('.alert.nav-check').filter(function () { 
				return (($(this).data().roundId == activeRoundId) == true);
			});
			return $(activeNavElement);
		};

		var detectNavCheckStatus = function (activeRoundId) {
			var activeNavCheck = $('.alert.nav-check').filter(function () { 
				if (($(this).data().roundId == activeRoundId) == true) {
					return $(this).data().status;
				};
			});
			return $(activeNavCheck).data().status;
		};

		var updateAlertNavCheck = function (element, message, pickDifference) {
			$element = $(element);
			$element.removeClass('alert-warning');
			$element.addClass('alert-danger');
			$element.html(message);
			$element.children('span').text(pickDifference)
		};

		// --- Round Display Toggle --- //
		// hides all round display except the active one
		var toggleRoundDisplay = function (activeRoundId) {
			console.log(activeRoundId);
		
			for (var i = 0; i < roundsCount; i++) {
				var searchTerm = '#' + roundsIds[i]
				var roundDisplay = $(searchTerm);
				if (roundsIds[i] == activeRoundId) {
					$activeRoundDisplay = $(searchTerm);
					$activeRoundDisplay.show();
				} else {
					$inactiveRoundDisplay = $(searchTerm);
					$inactiveRoundDisplay.hide();
				}
			}
		};

		// toggle between episode buttons (make active)
		// function for element - click into element
		var toggleEpisodeButton = function (element) {
			var classList = element.classList;

			var searchTerm = 'li'
			for (var i = 0; i < classList.length; i++) {
				switch (classList[i]) {
					case 'btn':
						searchTerm += '.' + classList[i]
						break;
					case 'btn-block':
						searchTerm += '.' + classList[i]
						break;
				}
			}
			$siblings = $(searchTerm).siblings();
			$siblings.removeClass('btn-primary selected');
			$(element).addClass('btn-primary selected');
		};

		// function for ID - change from environment
		var toggleEpisodeButtonById = function (roundId) {
			var searchTerm = 'li.btn.btn-block'
			$siblings = $(searchTerm).siblings();
			var element;

		
			for (var i = 0; i < $siblings.length; i++) {
				if ($siblings[i].dataset.roundId == roundId) {
					element = $siblings[i];
				}
			}
			$siblings.removeClass('btn-primary selected');
			$(element).addClass('btn-primary selected');
		};




		// detects which operation to execute

		var roundOperation = function (operation, contestantId, roundId, element) {
			$element = element;
			var $parent = $element.parentElement.parentElement.parentElement.parentElement;
		
			switch (operation) {
				case 'add-round':
					addContestantToRound(contestantId, roundId);
					break;
				case 'remove-round':
					removeContestantFromRound(contestantId, roundId);
					break;
			}
		};

		// ========= universal click listeners ========= //

		// HOVER listener
		$bracketBoard.on({
			mouseenter: function () {
				$(this).find('.thumbnail.contestant-thumbnail');
				$(this).toggleClass('hover');
				var $thumbnailFamily;
				$thumbnailFamily = $(this).children();
				$actionPanel = ($thumbnailFamily[3]);
				$actionPanel.setAttribute('style','display:block');
				},
			mouseleave: function () {
				$(this).find('.thumbnail.contestant-thumbnail');
				$(this).toggleClass('hover');
				$thumbnailFamily = $(this).children();
				$actionPanel = ($thumbnailFamily[3]);
				$actionPanel.setAttribute('style','display:none');
				}
		},'.thumbnail.contestant-thumbnail');

		// $('.thumbnail.contestant-thumbnail').hover(
		//  function (event) {
		//    var $thumbnailFamily;
		//    $(this).toggleClass('hover');
		//    $thumbnailFamily = $(this).children();
		//    $actionPanel = ($thumbnailFamily[3]);
		//    $actionPanel.setAttribute('style','display:block');
		//  }, function (event) {
		//    $(this).toggleClass('hover');
		//    $thumbnailFamily = $(this).children();
		//    $actionPanel = ($thumbnailFamily[3]);
		//    $actionPanel.setAttribute('style','display:none');
		//  }
		// );

		// // --- for adding/removing contestants from Round --- //
		$bracketBoard.on('click', $('.glyphicon'), function (event) {
			// records which element is being clicked
			$element = event.target;
			// set arguments for roundOperation
			var myClass = $element.className;
			var contestantId = $element.dataset.contestantId;
			var activeRoundId = detectActiveRoundByEnvironment();
			var roundId;
		
			// sets operation based on myClass value
			switch (myClass) {
				case 'glyphicon glyphicon-ok':
					var operation = 'add-round';
					roundId = $element.dataset.roundId;;
					break;
				case 'glyphicon glyphicon-remove':
					var operation = 'remove-round';
					roundId = $element.dataset.roundId;
					break;
			};

			roundOperation (operation, contestantId, roundId, $element);
		});
		
		// ========= for selecting Round ========= //
		// --------- Episode Board Buttons --------- //
		$episodeBoard.on('click', '.btn.btn-block.btn-sm', function (event) {
			$element = event.target; 
			debugger
			var roundId = $element.dataset.roundId;
			// toggleRoundDisplay(roundId);
			toggleEpisodeButton($element);
		});

		// --------- Previous/Next Buttons --------- //
		$bracketBoard.on('click', $('.round-toggle'), function (event) {
			$element = event.target; 
			var targetRoundId = $element.dataset.roundId;
			var leagueId = $element.parentElement.parentElement.dataset.leagueId;
			var status = $element.parentElement.parentElement.dataset.status;
			var action = $element.dataset.action;
			switch (action) {
				case 'previous':
					refreshRoundEditBoard(targetRoundId, leagueId);
					break;
				case 'next':
					refreshRoundEditBoard(targetRoundId, leagueId);
					break;
				case 'bulk-add':
					bulkAddContestantsToRound(targetRoundId);
					break;
			}
		});
	};
});
