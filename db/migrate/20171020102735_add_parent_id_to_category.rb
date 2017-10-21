class AddParentIdToCategory < ActiveRecord::Migration
  def change
    change_column :categories, :parent_category_id, 'integer USING CAST(parent_category_id AS integer)'
  end
end
