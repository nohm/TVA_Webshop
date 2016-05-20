module ApplicationHelper
	def full_title(page_title = '')
    base_title = "Smart Parts"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def cart_count(user)
  	cart = Cart.find_by(user_id: user.id, cart_status_id: search_status_id("In progress"))
  	cart_items = CartItem.where(cart_id: cart.id)
  	return cart_items.count
  end

  def search_status_id(string)
    return CartStatus.find_by(name: string).id
  end
end
