class AddStatusToCart < ActiveRecord::Migration
  def change
    add_reference :carts, :cart_status, index: true, foreign_key: true
  end
end
