class StaticPagesController < ApplicationController
  def home
    @part_actions = PartAction.where(active: true)

    # Integer used to keep track of the amount of recommendations used in "Populair products"
    @recommendation_count = 0

  	# Take 8 random recommendations
  	@partrecommendations = PartRecommendation.limit(8).order("RANDOM()")

  	# Get all purchases made in the last 2 weeks
  	carts = Cart.where(order_made_at: 2.weeks.ago..Time.now)
  	# Get all cart_items from the last 2 weeks
  	cart_items = CartItem.where(cart_id: carts.ids)
  	# place all part_ids in an array
  	count_part_ids = cart_items.pluck(:part_id)
  	count_hash = Hash.new(0)

  	# For every number in the array add it to the hash as { part_id => count }
  	count_part_ids.each do |v|
  		count_hash[v] += 1
  	end

  	# Sort the hash on descending order
  	count_hash = count_hash.sort_by { |k, v| v }.reverse

  	@part_ids = []

  	# Get the top 3 parts from the hash
  	count_hash.first(3).each do |array|
  		@part_ids << array[0]
  	end

  	# Find the top 3 parts
  	@parts = Part.find(@part_ids)
    # @parts = Part.where(id: part_ids)
    
  	# Make sure @parts is in the correct order that the hash was in
  	@parts.sort_by! { |p| @part_ids.index p[:id] }
  end

  def contact
  end
end
