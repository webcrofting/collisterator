$(document).ready(function() {
	$('.editable').editable('/items/1', {
			method: "PUT",
			submit: 'OK',
			name: 'item[data]'
	});
});
