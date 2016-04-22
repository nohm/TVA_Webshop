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
	Device();
	Brand();
	Model();
	Model_extended();	

	$('#myModal').modal('show');

	// Mouseover fuction for the thumbnails in part#show.
	$(".SmallImg").mouseover(function() {
		$(".BigImg").attr('src', $(this).data('hover'));
		$(".BigImgOriginal").attr('href', $(this).data('url'))
	})



	// Next 4 onchange events are for the dynamic search in parts_products#new
	$("#connection_device_select").change(function () {
		var id = $(this).val();
		var url = $(this).data('url');
		$.ajax({
      type: 'GET',
      url: url,
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
		var id = $("#device_id").val();
		var url = $(this).data('url');
		$.ajax({
      type: 'GET',
      url: url,
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
		var id = $("#device_id").val();
		var url = $(this).data('url');
		$("#product_id").attr('value', model);
		$.ajax({
      type: 'GET',
      url: url,
      data: { model: model, id: id, brand: brand },
      success: function(data){
      	if (data == "No model_extended") {
      		$('#connection_model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
      	} else {
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



	// Next 4 onchange events are for the dynamic search inside the header
	$("#device_select").change(function () {
		var id = $(this).val();
		var url = $(this).data('url');
		if (id){
			$.ajax({
	      type: 'GET',
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
		}	
	})

	$("#brand_select").change(function () {
		var brand = $(this).val();
		var id = $("#device_select").val();
		var url = $(this).data('url');
		if (brand) {
			$.ajax({
	      type: 'GET',
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
		} else {
			$('#model_select').prop("disabled", true).html('<option value="">Choose model</option>');
	    $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		}
	})

	$("#model_select").change(function () {
		var model = $(this).val();
		var brand = $("#brand_select").val();
		var device_id = $("#device_select").val();
		var url = $(this).data('url');
		if (model){
			$.ajax({
	      type: 'GET',
	      url: url,
	      data: { model: model, id: device_id, brand: brand },
	      success: function(data){
	        $('#model_extended_select').prop("disabled", false).html(data);
	      },
	      error: function(data){
	        $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
	      }
    	})
		} else {
			$('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		}
	})

	$("#model_extended_select").change(function () {
		var model_extended = $(this).val();
		var model = $('#model_select').val();
		var brand = $("#brand_select").val();
		var id = $("#device_select").val();
		var url = $(this).data('url');
		if (model_extended){
			$.ajax({
				type: 'GET',
				url: url,
				data: { model_extended: model_extended, brand: brand, id: id, model: model }
			})
		}
	})



	// AJAX PUT request for updating cart amount in cart.
	$(".amount").blur(function() {
	  var $this = $(this);
	  var row = $this.closest("tr");
	  var id = $this.data('id');
	  var cart_id = $this.data('cart');
	  var part_id = $this.data('part');
	  var url = $this.data('url');
	  var amount = $this.val();

	  var go = true
	  row.find("input.amount").each(function() {
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
			  url: url,
			  data: { cart_item: { cart_id: cart_id, part_id: part_id, amount: amount } }
			}).done(function() {
					location.reload(true);
				})
		}
	})

	// AJAX PUT request for updating delivery_method in cart.
	$("#delivery_method").change(function() {
		var method = $(this).val();
		var cart_id = $(this).data('cart');
		var url = $(this).data('url');

		$.ajax({
			method: "PUT",
			url: url,
			data: { cart: { delivery_method: method } },
			success: function(data){
				if (data == "Changed delivery method") {
					location.reload(true);
				}
			}
		})
	})



	// AJAX PUT request for updating location_id in cart.
	$("#cart_location_select").change(function() {
		var location_id = $(this).val();
		var cart_id = $(this).data('cart');
		var url = $(this).data('url');

		$.ajax({
			method: "PUT",
			url: url,
			data: { cart: { location_id: location_id } },
			success: function(data){
				if (data == "Changed location") {
					location.reload(true);
				}
			}
		})
	})



	// Change cart after purchase.
	$("#purchase").click(function () {
		$('#purchase').css({'cursor' : 'wait'});
		var cart_id = $(this).data('cart-id');
		var user_id = $(this).data('user-id');
		var coupon_code = $(this).data('coupon');
		var url = $(this).data('url');

		$.ajax({
			method: "GET",
			url: url,
			data: { user_id: user_id, cart_id: cart_id, coupon_code: coupon_code },
		  success: function(data){
		    if (data == "Purchase succeeded") {
		      location.reload(true);
		    }
		   }
		})
	})



	// Resize the price table at part#show on resize and load.
	var right = $(".right");
	var Table = $(".priceTable");
	var RightAlign = $(".RightAlign");
	$(window).resize(function() {
		if ($(window).width() < 754) {
      right.css('text-align', 'left');
      Table.css('width', '50%').css('float', 'left');
      RightAlign.css('float', 'left');
  	}
  	else {
  		right.css('text-align', 'right');
  		Table.css('width', '50%').css('float', 'right')
  		RightAlign.css('float', 'right')
  	}
	})
	.trigger('resize');



	// Change the preview of expiration date when creating a coupon.
	$("#days").change(function () {
		Expiration_date();
	});

	$("#hours").change(function () {
		Expiration_date();
	});



	// Automatically fills in #coupon_user_ids when you select a user.
	var edit_coupon_user = 0;
	$('#user_select').change(function () {
		var current = $('#coupon_user_ids').val();
		var new_val = $(this).val();
		
		if (edit_coupon_user == 0) {
			$('#coupon_user_ids').val(current + " " + new_val + " ");
			edit_coupon_user++;
		} else {
			$('#coupon_user_ids').val(current + new_val + " ");
		}
	});



	// Next 2 functions are for automatically filling in #coupon_category_ids when you select a category.
	$("#c_device_select").change(function () {
		var device_id = $(this).val();
		var url = $(this).data('url');
		if (device_id){
			$.ajax({
	      type: 'GET',
	      url: url,
	      data: { device_id: device_id },
	      success: function(data){
	        $('#c_category_select').prop("disabled", false).html(data);
	      },
	      error: function(data){
	      	$('#c_category_select').prop("disabled", true).html('<option value="">Choose category</option>');
	      }
	    })
		}	else {
			$('#c_category_select').prop("disabled", true).html('<option value="">Choose category</option>');
		}
	})

	var edit_coupon_category = 0;
	$("#c_category_select").change(function () {
		var current = $("#coupon_category_ids").val();
		var new_val = $(this).val();

		if (edit_coupon_category == 0) {
			$('#coupon_category_ids').val(current + " " + new_val + " ");
			edit_coupon_category++;
		} else {
			$('#coupon_category_ids').val(current + new_val + " ");
		}
	})



	// Next 3 functions are for automatically filling in #coupon_part_ids when you select a part.
	$("#p_device_select").change(function () {
		var device_id = $(this).val();
		var url = $(this).data('url');
		if (device_id){
			$.ajax({
	      type: 'GET',
	      url: url,
	      data: { device_id: device_id },
	      success: function(data){
	        $('#p_category_select').prop("disabled", false).html(data);
	        $('#p_part_select').prop("disabled", true).html('<option value="">Choose part</option>');
	      },
	      error: function(data){
	      	$('#p_category_select').prop("disabled", true).html('<option value="">Choose category</option>');
	      }
	    })
		}	else {
			$('#p_category_select').prop("disabled", true).html('<option value="">Choose category</option>');
			$('#p_part_select').prop("disabled", true).html('<option value="">Choose part</option>');
		}
	})

	$("#p_category_select").change(function () {
		var device_id = $("#p_device_select").val();
		var category_id = $(this).val();
		var url = $(this).data('url');
		if (category_id){
			$.ajax({
	      type: 'GET',
	      url: url,
	      data: { device_id: device_id, category_id: category_id },
	      success: function(data){
	        $('#p_part_select').prop("disabled", false).html(data);
	      },
	      error: function(data){
	      	$('#p_part_select').prop("disabled", true).html('<option value="">Choose category</option>');
	      }
	    })
		}	else {
			$('#p_part_select').prop("disabled", true).html('<option value="">Choose category</option>');
		}
	})

	var edit_coupon_part = 0;
	$("#p_part_select").change(function () {
		var current = $("#coupon_part_ids").val();
		var new_val = $(this).val();

		if (edit_coupon_part == 0) {
			$('#coupon_part_ids').val(current + " " + new_val + " ");
			edit_coupon_part++;
		} else {
			$('#coupon_part_ids').val(current + new_val + " ");
		}
	})


	// Checks if #coupon in cart#index has a current coupon and changes color based on that.
	if($('#coupon').length){
	  if($('#coupon').html().indexOf("None") >= 0){
	  	if ($('#coupon').hasClass('btn-success')) {
	      $('#coupon').removeClass('btn-success');
	      $('#coupon').addClass('btn-danger');
	    }
	  } else {
	  	if ($('#coupon').hasClass('btn-danger')) {
	      $('#coupon').removeClass('btn-danger');
	      $('#coupon').addClass('btn-success');
	    }
	  }
	};
});



// Get parameters from the URL
function getURLParameter(name) {
	return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
}

// Next 4 functions are for automatically filling in the dynamic search options with the current product they are in.
function Device() {
	var path = window.location.pathname.toString().split("products/");
	var device_path = window.location.pathname.toString().split("devices/");
	if (typeof path[1] !== 'undefined' && path[1] != 'new') {
		var product = path[1].split("/");
		var p_id = product[0];
		var url = $("#device_select").data('urlself');
		if(p_id) {
			$.ajax({
		    type: 'GET',
		    url: url,
		    data: { p_id: p_id },
		    success: function(data){
		    	$('#device_select').html(data);
		    }
		  })
		}
	} else if (typeof device_path[1] !== 'undefined' && path[1] != 'new') {
		var device = device_path[1].split("/");
		var d_id = device[0];
		var url = $("#device_select").data('urlself');
		if(d_id) {
			$.ajax({
				type: 'GET',
				url: url,
				data: { d_id: d_id },
				success: function(data){
					$('#device_select').html(data);
				}
			})
		}
	}
}

function Brand() {
	var path = window.location.pathname.toString().split("products/");
	var device_path = window.location.pathname.toString().split("devices/");
	if (typeof path[1] !== 'undefined' && path[1] != 'new') {
		var product = path[1].split("/");
		var p_id = product[0];
		var url = $("#device_select").data('url');
		if(p_id) {
			$.ajax({
		    type: 'GET',
		    url: url,
		    data: { p_id: p_id },
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
		}
	} else if (typeof device_path[1] !== 'undefined' && path[1] != 'new') {
		var device = device_path[1].split("/");
		var d_id = device[0];
		var brand = getURLParameter('brand');
		var url = $("#device_select").data('url');
		if(d_id) {
			$.ajax({
				type: 'GET',
				url: url,
				data: { d_id: d_id, brand: brand },
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
		}
	}
}

function Model() {
	var path = window.location.pathname.toString().split("products/");
	var device_path = window.location.pathname.toString().split("devices/");
	if (typeof path[1] !== 'undefined' && path[1] != 'new') {
		var product = path[1].split("/");
		var p_id = product[0];
		var url = $("#brand_select").data('url');
		if(p_id) {
			$.ajax({
		    type: 'GET',
		    url: url,
		    data: { p_id: p_id },
		    success: function(data){
		      $('#model_select').prop("disabled", false).html(data);
		      $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		    },
		    error: function(data){
		      $('#model_select').prop("disabled", true).html('<option value="">Choose model</option>');
		      $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		    }
		  })
		}
	} else if (typeof device_path[1] !== 'undefined' && path[1] != 'new') {
		var device = device_path[1].split("/");
		var d_id = device[0];
		var brand = getURLParameter('brand');
		var model = getURLParameter('model');
		var url = $("#brand_select").data('url');
		if(brand) {
			$.ajax({
				type: 'GET',
				url: url,
				data: { d_id: d_id, brand: brand, model: model },
		    success: function(data){
		      $('#model_select').prop("disabled", false).html(data);
		      $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		    },
		    error: function(data){
		      $('#model_select').prop("disabled", true).html('<option value="">Choose model</option>');
		      $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		    }
			})
		}
	}
}

function Model_extended() {
	var path = window.location.pathname.toString().split("products/");
	var device_path = window.location.pathname.toString().split("devices/");
	if (typeof path[1] !== 'undefined' && path[1] != 'new') {
		var product = path[1].split("/");
		var p_id = product[0];
		var url = $("#model_select").data('url');
		if(p_id) {
			$.ajax({
		    type: 'GET',
		    url: url,
		    data: { p_id: p_id },
		    success: function(data){
		    	if (data != "No Extended") {
		      	$('#model_extended_select').html(data).prop("disabled", false);
		    	} else {
		    		$('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		    	}
		    },
		    error: function(data){
		      $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		    }
		  })
		}
	} else if (typeof device_path[1] !== 'undefined' && path[1] != 'new') {
		var device = device_path[1].split("/");
		var d_id = device[0];
		var brand = getURLParameter('brand');
		var model = getURLParameter('model');
		var url = $("#model_select").data('url');
		if(model) {
			$.ajax({
		    type: 'GET',
		    url: url,
		    data: { d_id: d_id, brand: brand, model: model },
		    success: function(data){
		    	if (data != "No Extended") {
		      	$('#model_extended_select').html(data).prop("disabled", false);
		    	} else {
		    		$('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		    	}
		    },
		    error: function(data){
		      $('#model_extended_select').prop("disabled", true).html('<option value="">Choose model</option>');
		    }
		  })
		}
	}
}



// Function for filling in the expiration date example in coupons#new and coupons#edit.
function Expiration_date() {
	var days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
	var DaysToAdd = $("#days").val();
	var HoursToAdd = $("#hours").val();
	var date = new Date();
	var newDate = new Date(date.setTime( date.getTime() + DaysToAdd * 86400000 ));
	var day = newDate.getUTCDate();
	var month = (newDate.getUTCMonth() +1);
	var year = newDate.getUTCFullYear();
	var weekday = days[ newDate.getUTCDay() ];
	$("#expiration_date_hour").html("");
	$("#expiration_date_hour").append("Expires on: " + weekday + ", " + day + "-" + month + "-" + year + " " + HoursToAdd + ":00:00 UTC");
}