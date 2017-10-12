class Category < ActiveRecord::Base
	has_and_belongs_to_many :posts
	belongs_to :user
end
