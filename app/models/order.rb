class Order < ActiveRecord::Base
  attr_accessor :credit_card

  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
end
