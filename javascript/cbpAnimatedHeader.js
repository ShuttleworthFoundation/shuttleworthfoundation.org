 $(document).ready(function() {
	$('#header-21 .dropdown').find(".dropdown-menu").each(function() {
	  $(this).addClass("subnav");
	  $(this).removeClass("dropdown-menu");
	});
  });