class AddParentIdToCategory < ActiveRecord::Migration
  def change
    adapter_type = connection.adapter_name.downcase.to_sym
    case adapter_type
      when :postgresql
        change_column :categories, :parent_category_id, 'integer USING CAST(parent_category_id AS integer)'
      else
        change_column :categories, :parent_category_id, 'integer'
    end
  end
end
