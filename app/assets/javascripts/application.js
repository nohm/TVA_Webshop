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
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .


$(document).on('ready page:load', function () {
	// Mouseover fuction for the thumbnails in part#show.
	$(".SmallImg").mouseover(function() {
		$(".BigImg").attr('src', $(this).data('hover'));
		$(".BigImgOriginal").attr('href', $(this).data('url'))
	})



	//Dynamic search for id in parts_products#new
	$("#connection_device_select").change(function () {
		var id = $(this).val();
		$.ajax({
      type: 'POST',
      url: '/connect_brand',
      data: { id: id },
      success: function(data){
        $('#connection_brand_select').prop("disabled", false).html(data);
        $('#connection_model_select').prop("disabled", true).html('<option value="">Choose model</option>');
        $('#connection_model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      },
      error: function(data){
      	$('#connection_brand_select').prop("disabled", true).html('<option value="">Choose brand</option>');
        $('#connection_model_select').prop("disabled", true).html('<option value="">Choose model</option>');
        $('#connection_model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      }
    })
	})

	$("#connection_brand_select").change(function () {
		var brand = $(this).val();
		var id = $("#connection_device_select").val();
		$.ajax({
      type: 'POST',
      url: '/connect_model',
      data: { brand: brand, id: id },
      success: function(data){
        $('#connection_model_select').prop("disabled", false).html(data);
        $('#connection_model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');;
      },
      error: function(data){
        $('#connection_model_select').prop("disabled", true).html('<option value="">Choose model</option>');
        $('#connection_model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      }
    })
	})

	$("#connection_model_select").change(function () {
		var model = $(this).val();
		var brand = $("#connection_brand_select").val();
		var device_id = $("#connection_device_select").val();
		$("#product_id").attr('value', model);
		$.ajax({
      type: 'POST',
      url: '/connect_model_extended',
      data: { model: model, id: device_id, brand: brand },
      success: function(data){
      	if (data == "No model_extended") {
      		$('#connection_model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      	}
      	else {
        	$('#connection_model_extended_select').prop("disabled", false).html(data);
        	$('#Submit_connect').prop("disabled", true)
      	}
      }
    })
	})

	$("#connection_model_extended_select").change(function () {
		var model = $(this).val();
		$("#product_id").attr('value', model);
		$('#Submit_connect').prop("disabled", false)
	})



	//Dynamic search
	$("#device_select").change(function () {
		var id = $(this).val();
		var url = $(this).data('url');
		$.ajax({
      type: 'POST',
      url: url,
      data: { id: id },
      success: function(data){
        $('#brand_select').prop("disabled", false).html(data);
        $('#model_select').prop("disabled", true).html('<option value="">Choose model</option>');
        $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      },
      error: function(data){
      	$('#brand_select').prop("disabled", true).html('<option value="">Choose brand</option>');
        $('#model_select').prop("disabled", true).html('<option value="">Choose model</option>');
        $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      }
    })
	})

	$("#brand_select").change(function () {
		var brand = $(this).val();
		var id = $("#device_select").val();
		var url = $(this).data('url');
		$.ajax({
      type: 'POST',
      url: url,
      data: { brand: brand, id: id },
      success: function(data){
        $('#model_select').prop("disabled", false).html(data);
        $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');;
      },
      error: function(data){
        $('#model_select').prop("disabled", true).html('<option value="">Choose model</option>');
        $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      }
    })
	})

	$("#model_select").change(function () {
		var model = $(this).val();
		var brand = $("#brand_select").val();
		var device_id = $("#device_select").val();
		var url = $(this).data('url');
		$.ajax({
      type: 'POST',
      url: url,
      data: { model: model, id: device_id, brand: brand },
      success: function(data){
        $('#model_extended_select').prop("disabled", false).html(data);
      },
      error: function(data){
        $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      }
    })
	})

	$("#model_extended_select").change(function () {
		var model_extended = $(this).val();
		var brand = $("#brand_select").val();
		var id = $("#device_select").val();
		var url = $(this).data('url');
		$.ajax({
			type: 'POST',
			url: url,
			data: { model_extended: model_extended, brand: brand, id: id },
		})
	})



	// AJAX PUT request for updating cart amount in cart.
	$(".amount").blur(function() {
	  var $this = $(this);
	  var $row = $this.closest("tr");
	  var $id = $this.data('id');
	  var $user_id = $this.data('user');
	  var $part_id = $this.data('part');
	  var $amount = $this.val();

	  var go = true
	  $row.find("input.amount").each(function() {
	    if (isNaN(this.value)) {
	      go = false;
	      $(this).css("border", "1px solid red");
	    } else {
	      $(this).css("border", "");
	    }
	  })

	  if (go) {
		  $.ajax({
			  method: "PUT",
			  url: "/carts/" + $id,
			  data: { cart: { user_id: $user_id, part_id: $part_id, amount: $amount } }
			}).done(function() {
				location.reload(true);
			})
		}
	})



	//Resize the price table at part#show on resize and load.
	var Right = $(".Right");
	var Table = $(".PriceTable");
	var RightAlign = $(".RightAlign");
	$(window).resize(function() {
		if ($(window).width() < 754) {
      Right.css('text-align', 'left');
      Table.css('width', '50%').css('float', 'left');
      RightAlign.css('float', 'left');
  	}
  	else {
  		Right.css('text-align', 'right');
  		Table.css('width', '50%').css('float', 'right')
  		RightAlign.css('float', 'right')
  	}
	})
	.trigger('resize');
});
