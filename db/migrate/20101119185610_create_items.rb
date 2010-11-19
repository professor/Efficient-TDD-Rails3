class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :order_id
      t.string :name
      t.text :description
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
    
    create_table :orders_items, :id => false do |t|
      t.integer :order_id
      t.integer :item_id
    end
    
    add_index :items, :order_id
    add_index :orders_items, :order_id
    add_index :orders_items, :item_id
  end

  def self.down
    drop_table :items
    drop_table :orders_items   
  end
end
