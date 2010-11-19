class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :items, :join_table => "orders_items"
  
  validates :user, :presence => true
end
