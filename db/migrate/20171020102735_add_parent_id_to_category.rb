class AddParentIdToCategory < ActiveRecord::Migration
  def change
    change_column :categories, :parent_category_id, :integer
  end
end
