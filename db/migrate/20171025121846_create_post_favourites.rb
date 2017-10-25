class CreatePostFavourites < ActiveRecord::Migration
  def change
    create_table :post_favourites do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps null: false
    end
  end
end
