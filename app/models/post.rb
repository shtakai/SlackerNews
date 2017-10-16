class Post < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :categories

	validates :title, presence: true
	validates :url, presence: true

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

end
