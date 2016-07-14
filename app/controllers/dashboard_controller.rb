class DashboardController < ApplicationController
  layout 'new_layout'

  def purchases
    redirect_to index_path unless current_user.present? # landing page
    @product_items = ProductItem.select('DISTINCT ON (product_items.id) product_items.*')
                                .joins(product: { order_items: :order })
                                .where('orders.user_id = ?', current_user.id)
    render 'dashboard/index'
  end
end
