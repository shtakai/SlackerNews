class Post < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :categories

	validates :title, presence: true
	validates :url, presence: true
	validate :is_valid_url

	has_many :votes
	has_many :comments

	def vote(user, amount)
		vo = self.votes.find_or_initialize_by(user: user)
		vo.amount = amount
		vo.save
	end

	def score
		score = 0
		self.votes.each do |vote|
			score += vote.amount
		end

		return score
	end

	def is_valid_url
		uri = self.url
		require 'uri'
		uri = URI.parse(url)
  		if not  uri.is_a?(URI::HTTP) && !uri.host.nil?
  			errors.add(:url, "must be a valid Url - Sherlock")
  		end
  	rescue URI::InvalidURIError
			errors.add(:url, "must be a valid Url - Sherlock")
	end

end
