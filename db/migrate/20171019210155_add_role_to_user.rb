class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role_cd, :integer, :default => 1
    add_column :users, :approved, :boolean, :default => false
  end
end
