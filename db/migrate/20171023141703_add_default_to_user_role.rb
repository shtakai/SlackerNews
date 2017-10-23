class AddDefaultToUserRole < ActiveRecord::Migration
  def change
    change_column :users, :role_cd, :integer, :default => 1
  end
end
