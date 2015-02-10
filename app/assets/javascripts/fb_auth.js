var status = null;

var updateFbButtonLabel = function (message) {
	$('#fb-login-button').text(message);
};

var executeFbInteraction = function (scenario, userId) {
	if (scenario === null) {
		return;
	} else {
		switch (scenario) {
			case 'noFbConnection-link', 'notAuthorized-link':
				linkFbUser(userId);
				break;
			case '':
				break;
		}
	};
};

var processFbInteraction = function (currentStatus, action, userId) {
	// set variable for below switch
	var scenario = '';

	if (currentStatus === null || action === null)  {
		// This scenario is when Facebook status cound not be established
		// and no value is assigned to "action" or variable does not exist
		scenario = 'fbError';
	} else if (currentStatus === 'not_authorized' && action === 'signup-fb') {
		// User is logged into Facebook but not to the app
		// First time signing up via Facebook
		scenario = 'B';
	} else if (currentStatus === 'not_authorized' && action === 'signin-fb') {
		// User is logged into Facebook but not to the app
		// Current user signing in with Facebook
		scenario = 'C';
	} else if (currentStatus === 'not_authorized' && action === 'link-fb') {
		// User is logged into Facebook but not to the app
		// Current user want to link account to FB for future use
		updateFbButtonLabel('Link account to Facebook');
		scenario = 'notAuthorized-link';
	} else if (currentStatus === 'unknown' && action === 'signup-fb') {
		updateFbButtonLabel('Sign up with Facebook');
		scenario = 'noFbConnection-signup';
	} else if (currentStatus === 'unknown' && action === 'signin-fb') {
		scenario = 'noFbConnection-signin';
	} else if (currentStatus === 'unknown' && action === 'link-fb') {
		updateFbButtonLabel('Link account to Facebook');
		scenario = 'noFbConnection-link';
	};

	executeFbInteraction(scenario, userId);

};



// This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response) {
	console.log('Initiate statusChangeCallback');
	// The response object is returned with a status field that lets the
	// app know the current login status of the person.
	// Full docs on the response object can be found in the documentation
	// for FB.getLoginStatus().
	if (response.status === 'connected') {
		// Logged into your app and Facebook.
		updateFbButtonLabel('I am connected');
	} else if (response.status === 'not_authorized') {
		// The person is logged into Facebook, but not your app.
		updateFbButtonLabel('i am not authorized');
	} else {
		// The person is not logged into Facebook, so we're not sure if
		// they are logged into this app or not.
	}
}

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

	FB.getLoginStatus(function(response) {
		statusChangeCallback(response);
		status = response.status;
	});
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

var postUserInfo = function (data, userId) {
	var url = '/users/' + userId;
	var data = {
		email: data.email,
		fbId: data.id,
		oauth_token: 

	};

	$.ajax({
		url: url,
		data: {user: data}
		}
	);
};

var unlinkFbUser = function () {

};

var linkFbUser = function (userId) {
	console.log('got to link');
	fbLoginFunction();
};

var signupFbUser = function () {

};

var fbLoginFunction = function (userId) {
	FB.login(function(response){
		if (response.status === 'connected') {
			// Permission from Facebook.
			FB.api('/me', function (response) {
				postUserInfo(response, userId)
			});
		} else if (response.status === 'not_authorized') {
			// The person is logged into Facebook, but not your app.
			var userId = $('#fb-login-button').data().userId
			console.log(userId)

			console.log(response);
		} else {
			// The person is not logged into Facebook, so we're not sure if
			// they are logged into this app or not.
		}
	}, {
		scope: 'user_friends, email', 
		return_scopes: true
	});
};