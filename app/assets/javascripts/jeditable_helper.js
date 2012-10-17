$(document).ready(function() {
	$('.edit').editable(function(value, settings) {
		console.log(this);
		console.log(value);
		console.log(settings);
		return (value);
	} , {
		type : 'textarea',
		submit : 'ok',
	});
});