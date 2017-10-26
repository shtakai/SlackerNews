class AddVoteCacheToPost < ActiveRecord::Migration
  def change
    add_column :posts, :vote_cache, :integer, :default => 0
    add_column :users, :karma_cache, :integer, :default => 0
  end
end
