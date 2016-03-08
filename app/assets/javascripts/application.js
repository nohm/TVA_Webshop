// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .


$(document).on('ready page:load', function () {
	$(".SmallImg").mouseover(function() {
		$(".BigImg").attr('src', $(this).data('hover'));
	})

	var Right = $(".Right");
	var Table = $(".PrijsTable");
	var RightAlign = $(".RightAlign");
	var Small = $(".Small");
	$(window).resize(function() {
		if ($(window).width() < 754) {
      Right.css('text-align', 'left');
      Table.css('width', '50%').css('float', 'left');
      RightAlign.css('float', 'left');
      Small.css('margin-right', '0px').css('margin-left', '14px');
  	}
  	else {
  		Right.css('text-align', 'right');
  		Table.css('width', '50%').css('float', 'right')
  		RightAlign.css('float', 'right')
  	}
	})

	/*$("#Afrekenen").click(function() {
		$.ajax({
		  method: "POST",
		  url: "/cart",
		  data: 
		})
	})*/
});
