class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :desc
      t.string :parent_category_id
      t.string :user_id

      t.timestamps null: false
    end
  end
end
