class PartsController < ApplicationController
  def index
    # Checks if it can find the flash
    if flash[:item_added]
      # Parameters used for the modal _cart_show_modal.html.erb inside parts view
      @cart = Cart.find_by(user_id: current_user.id, cart_status_id: search_status_id("In progress"))
      @cart_items = CartItem.where(cart_id: @cart.id).order('id')
    end

    @parts_products = PartsProduct.where(product_id: params[:product_id]).page(params[:page]).per(10).order('id ASC')
    @part_amount = 0
    # Check which part_products belongs to the category someone is viewing
    @parts_products.each do |part_product|
      if part_product.part.category_id == params[:category_id].to_i
        @part_amount += 1
      end
    end
    @cart_item = CartItem.new
    @reminder = Reminder.new
    @partrecommendation = PartRecommendation.new
  end

  def show
    # Checks if it can find the flash
    if flash[:item_added]
      # Parameters used for the modal _cart_show_modal.html.erb inside parts view
      @cart = Cart.find_by(user_id: current_user.id, cart_status_id: search_status_id("In progress"))
      @cart_items = CartItem.where(cart_id: @cart.id).order('id')
    end
    @part = Part.find(params[:id])
    @cart_item = CartItem.new
    @reminder = Reminder.new
    @stock = PartStock.where(part_id: @part.id).sum('stock')
    @partimages = Partimage.where(part_id: params[:id])
    @descriptions = Partdescription.where(part_id: params[:id]).order('title ASC')
    @discount_prices = DiscountPrice.where(part_id: params[:id]).order('amount ASC')
  end

  def new
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @part = Part.new
  end

  def create
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    params[:part][:category_id] = params[:category_id]
    params[:part][:device_id] = params[:device_id]
    # Replace comma's with dots
    price = params[:part][:price].to_s.gsub(',', '.').to_f
    @part = Part.new(part_params)
    condition = params[:part][:condition]
    condition_select = params[:part][:condition_select]
    brand = params[:part][:brand]
    brand_select = params[:part][:brand_select]

    # Custom validation to see if both brand_select and brand are empty or both filled in
    if (brand.blank? && brand_select.blank?) || (!brand.blank? && !brand_select.blank?)
      flash[:half_notice] = "Either choose an existing brand or create a new one"
      render 'new' and return
    end

    # Custom validation to see if both condition_select and condition are empty or both filled in
    if (condition.blank? && condition_select.blank?) || (!condition.blank? && !condition_select.blank?)
      flash[:half_notice] = "Either choose an existing condition or create a new one"
      render 'new' and return
    end

    @part.condition = condition_select if condition.blank?
    @part.brand = brand_select if brand.blank?
    
    if @part.save
      DiscountPrice.create(part_id: @part.id, amount: 1, price: price)
      PartsProduct.create(part_id: @part.id, product_id: params[:product_id])
      PartStock.create(part_id: @part.id, stock: params[:part][:stock], location_id: params[:part][:location_id], sublocation_id: params[:part][:sublocation_id])
      redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
      flash[:success] = "Part added"
    else
      @location_id = params[:part][:location_id]
      @condition = @part.condition
      @brand = @part.brand
      render 'new'
    end
  end

  def edit
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @part = Part.find(params[:id])
  end

  def update
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    @part = Part.find(params[:id])
    condition = params[:part][:condition]
    condition_select = params[:part][:condition_select]
    brand = params[:part][:brand]
    brand_select = params[:part][:brand_select]

    # Custom validation to see if both brand_select and brand are empty or both filled in
    if (brand.blank? && brand_select.blank?) || (!brand.blank? && !brand_select.blank?)
      flash[:half_notice] = "Either choose an existing brand or create a new one"
      render 'edit' and return
    end

    # Custom validation to see if both condition_select and condition are empty or both filled in
    if (condition.blank? && condition_select.blank?) || (!condition.blank? && !condition_select.blank?)
      flash[:half_notice] = "Either choose an existing condition or create a new one"
      render 'edit' and return
    end

    params[:part][:condition] = condition_select if condition.blank?
    params[:part][:brand] = brand_select if brand.blank?

    if @part.update(part_params)
      redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
      flash[:success] = "Part updated"
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to root_path, :notice => "Unauthorized" and return unless logged_in? && current_user.manager?
    part = Part.find(params[:id])
    part.destroy
    redirect_to device_product_category_parts_path(params[:device_id], params[:product_id], params[:category_id])
    flash[:success] = "Part deleted"
  end

  def send_tell_a_friend
    user  = current_user
    part  = params[:tell_a_friend][:part_id].to_i
    email = params[:tell_a_friend][:email]
    Mailer.send_tell_a_friend(user, email, part).deliver_now
    flash[:success] = "Email has been sent"
    redirect_to request.referrer
  end

  private

  def part_params
    params.require(:part).permit(:category_id, :name, :condition, :warranty, :price, :stock, :partimagefull, :brand, :weight, :location_id, :sublocation_id, :partnumber)
  end
end
