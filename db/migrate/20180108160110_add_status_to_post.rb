class AddStatusToPost < ActiveRecord::Migration
  def change
    add_column :posts, :status_cd, :integer, :default => 1
    Post.reset_column_information
    Post.update_all(status_cd: 1)
  end
end
