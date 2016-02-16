class Post < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :categories

	validates :title, presence: true
	validates :url, presence: true
end
