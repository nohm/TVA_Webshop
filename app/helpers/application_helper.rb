module ApplicationHelper
  # Method for adding a title to the page
	def full_title(page_title = '')
    base_title = "Smart Parts"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # Method for counting how many different parts are in your cart
  def cart_count(user)
  	if Cart.find_by(user_id: user.id, cart_status_id: search_status_id("In progress")).blank?
      Cart.create(user_id: user.id, purchased: false, delivery_method: "Shipping", cart_status_id: search_status_id("In progress"))
    end
    cart = Cart.find_by(user_id: user.id, cart_status_id: search_status_id("In progress"))
  	cart_items = CartItem.where(cart_id: cart.id)
  	return cart_items.count
  end

  # Method for finding a cart_status id
  def search_status_id(string)
    return CartStatus.find_by(name: string).id
  end
end
