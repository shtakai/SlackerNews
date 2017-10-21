class AddParentIdToCategory < ActiveRecord::Migration
  def change
    change_column :categories, :parent_category_id, 'integer USING CAST(column_name AS integer)'
  end
end
