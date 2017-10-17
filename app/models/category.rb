class Category < ActiveRecord::Base
	has_and_belongs_to_many :posts
	belongs_to :user
    has_many :category_subscriptions
    has_many :subscribers, through: :category_subscriptions, :source => :user
end
