var createUser = function (name, email) {
	var dataPackage = {
		"user": {
			username: name,
			email: email
		}
	};

	$.ajax({
		url: '/users', 
		type: 'POST', 
		data: dataPackage,
		success: function () {

		}
	});
	console.log('got here');
};

var newUserFacebook = function(data) {
	console.log(data);
	createUser(data.name, data.email);
};