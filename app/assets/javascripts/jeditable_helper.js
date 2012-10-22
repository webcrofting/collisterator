$(document).ready(function() {
	$('.editable').editable('/items/1/update', {
			method: "PUT",
			submit: 'OK'
	});
});
