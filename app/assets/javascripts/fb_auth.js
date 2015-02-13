	var postData = function (response, data, url) {
		FB.api('/me', { fields: 'email, timezone, picture' }, function (response) {
			console.log(response.picture.data.url);
			data.user.avatar = response.picture.data.url;
			data.user.email = response.email;
			data.user.timezone = response.timezone;
			$.ajax({
				async: 		false,
				url: 			url,
				type: 		'POST',
				data: 		data,
				success: 	function () {
				}
			});
			console.log(data);
		});
	};

var loginUser = function (response) {
	console.log(response.authResponse.userID);
	var fbId = response.authResponse.userID;
	var url = '/login/fb';
	var compiler = {};

	compiler = {
		user: {
			oauth_provider: 'Facebook',
			oauth_id: 			response.authResponse.userID	
		}
	};
	postData(response, compiler, url);
};

var linkUser = function (response, userId) {
	var url = '/users/' + userId + '/link_fb';
	// compile user data
	var compiler = {};
	if (response.status != null) {
		compiler = {
			user: {
				oauth_provider: 'Facebook',
				oauth_id: 			response.authResponse.userID
			}
		};
	} else {
		// User closes permission dialogue before completion
		console.log('boo you didnt let me in!');
	}
	postData(response, compiler, url);
};

var unlinkUser = function (userId) {
	var url = '/users/' + userId + '/unlink_fb';
	$.ajax({
		url: 			url,
		success: 	function () {
		}
	}).done(function () {

	});
};

// This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response, userId, _action) {
	console.log('Initiate statusChangeCallback');
	var action = [];
	// The response object is returned with a status field that lets the
	// app know the current login status of the person.
	// Full docs on the response object can be found in the documentation
	// for FB.getLoginStatus().

	// Switch case determine ACTION
	switch (_action) {
		case 'fb-signup':
			action[0] = 'signup';
			break;
		case 'fb-login':
			action[0] = 'login';
			break;
		case 'fb-logout':
			action[0] = 'logout';
			break;
		case 'fb-link':
			action[0] = 'link';
			break;
		case 'fb-unlink':
			action[0] = 'unlink';
			break;
		default:
			action[0] = 'undetermined';
			break;
	};

	// Switch case determine STATUS
	switch (response.status) {
		case 'connected':
			// Logged into your app and Facebook.
			action[1] = 'connected';
			break;
		case 'not_authorized':
			// The person is logged into Facebook, but not authorized to your app.
			action[1] = 'not_authorized';
			break;
		default:
			// The person is not logged into Facebook, so we're not sure if
			// they are logged into this app or not.
			action[1] = 'unknown';
			break;
	};

	if (action[0] === 'signup' && action[1] ==='not_authorized') {
		// User wants to signup but hasn't granted permission
		// Social signup
		console.log('AA');
	} else if	(action[0] === 'signup' && action[1] ==='unknown') {
		// User wants to signup with unknown Facebook status
		// must login first
		// Social signup
		// --------######!!!!!!
		console.log('BB');
	} else if (action[0] === 'login' && action[1] ==='connected') {
		// Linked user wants to login with FB
		// Social signin
		// !!!!!!----------------------
		loginUser(response, userId);
	} else if (action[0] === 'unlink' && action[1] === 'connected') {
		fbLoginAPI(response, userId, unlinkUser);
	} else {
		// - 'login', 'not_authorized'
		// User who signed up locally wants to login with FB
		// - 'login', 'unknown'
		// User who signed up locally wants to login with FB
		// - 'link', 'unknown'
		// User who signed up locally wants to link with unknown FB
		// - 'link', 'not_authorized'
		// User who signed up locally wants to link with FB
		linkUser(response, userId);
	};
};


// This function is called when someone finishes with the Login
// Button.  See the onlogin handler attached to it in the sample
// code below.
function checkLoginState() {
	FB.getLoginStatus(function(response) {
		statusChangeCallback(response);
	});
}

window.fbAsyncInit = function() {
	FB.init({
		appId      : '1488570754762932',
		cookie     : true,  // enable cookies to allow the server to access 
												// the session
		xfbml      : true,  // parse social plugins on this page
		version    : 'v2.1' // use version 2.1
	});

	// Now that we've initialized the JavaScript SDK, we call 
	// FB.getLoginStatus().  This function gets the state of the
	// person visiting this page and can return one of three states to
	// the callback you provide.  They can be:
	//
	// 1. Logged into your app ('connected')
	// 2. Logged into Facebook, but not your app ('not_authorized')
	// 3. Not logged into Facebook and can't tell if they are logged into
	//    your app or not.
	//
	// These three cases are handled in the callback function.

	// FB.getLoginStatus(function(response) {
	// 	statusChangeCallback(response);
	// 	status = response.status;
	// });
};

// Load the SDK asynchronously
(function(d, s, id) {
	var js, fjs = d.getElementsByTagName(s)[0];
	if (d.getElementById(id)) return;
	js = d.createElement(s); js.id = id;
	js.src = "//connect.facebook.net/en_US/sdk.js";
	fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

// Here we run a very simple test of the Graph API after login is
// successful.  See statusChangeCallback() for when this call is made.
function testAPI() {
	console.log('Welcome!  Fetching your information.... ');
	FB.api('/me', function(response) {
		console.log(response);
		console.log('Successful login for: ' + response.name);
		document.getElementById('status').innerHTML =
			'Thanks for logging in, ' + response.name + '!';
	});
};
