// JavaScript Document
// --------------------------------------------------------------------------------	

var site_container_padding_top = 100; /* depends on layout.css -> div#site_container -> padding-top */

// --------------------------------------------------------------------------------	

var resizeContentInner = function () {
	$('.site_container_inner').height(
		$(window).height()-$('#site_footer').outerHeight()-site_container_padding_top);
}

// --------------------------------------------------------------------------------	

$(window).ready(resizeContentInner);
$(window).resize(resizeContentInner);

// --------------------------------------------------------------------------------	